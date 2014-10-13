
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2006-2012 The OpenNMS Group, Inc.
 * OpenNMS(R) is Copyright (C) 1999-2012 The OpenNMS Group, Inc.
 *
 * OpenNMS(R) is a registered trademark of The OpenNMS Group, Inc.
 *
 * OpenNMS(R) is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * OpenNMS(R) is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OpenNMS(R).  If not, see:
 *      http://www.gnu.org/licenses/
 *
 * For more information contact:
 *     OpenNMS(R) Licensing <license@opennms.org>
 *     http://www.opennms.org/
 *     http://www.opennms.com/
 *******************************************************************************/

package org.opennms.netmgt.poller.monitors;

import java.net.InetAddress;
import java.util.Map;

import org.apache.regexp.RE;
import org.apache.regexp.RESyntaxException;
import org.opennms.core.utils.LogUtils;
import org.opennms.core.utils.ParameterMap;
import org.opennms.core.utils.TimeoutTracker;
import org.opennms.netmgt.model.PollStatus;
import org.opennms.netmgt.poller.Distributable;
import org.opennms.netmgt.poller.MonitoredService;
import org.opennms.netmgt.poller.NetworkInterface;
import org.opennms.netmgt.poller.NetworkInterfaceNotSupportedException;
import org.opennms.netmgt.protocols.InsufficientParametersException;
import org.opennms.netmgt.protocols.ssh.Ssh;

/**
 * This class is designed to be used by the service poller framework to test the
 * availability of SSH remote interfaces. The class
 * implements the ServiceMonitor interface that allows it to be used along with
 * other plug-ins by the service poller framework.
 *
 * @author <a href="mailto:ranger@opennms.org">Benjamin Reed</a>
 * @author <a href="http://www.opennms.org/">OpenNMS</a>
 * @author <a href="mailto:ranger@opennms.org">Benjamin Reed</a>
 * @author <a href="http://www.opennms.org/">OpenNMS</a>
 * @version $Id: $
 */

@Distributable
final public class SshMonitor extends AbstractServiceMonitor {

    private static final int DEFAULT_RETRY = 0;
    /** Constant <code>DEFAULT_TIMEOUT=3000</code> */
    public static final int DEFAULT_TIMEOUT = 3000;
    /** Constant <code>DEFAULT_PORT=22</code> */
    public static final int DEFAULT_PORT = 22;

    /**
     * {@inheritDoc}
     *
     * Poll an {@link InetAddress} for SSH availability.
     *
     * During the poll an attempt is made to connect on the specified port. If
     * the connection request is successful, the banner line generated by the
     * interface is parsed and if the banner text indicates that we are talking
     * to Provided that the interface's response is valid we mark the poll status
     * as available and return.
     */
    public PollStatus poll(InetAddress address, Map<String,Object> parameters) {

        TimeoutTracker tracker = new TimeoutTracker(parameters, DEFAULT_RETRY, DEFAULT_TIMEOUT);

        int port = ParameterMap.getKeyedInteger(parameters, "port", DEFAULT_PORT);
        String banner = ParameterMap.getKeyedString(parameters, "banner", null);
        String match = ParameterMap.getKeyedString(parameters, "match", null);
        String clientBanner = ParameterMap.getKeyedString(parameters, "client-banner", Ssh.DEFAULT_CLIENT_BANNER);
        PollStatus ps = PollStatus.unavailable();
        
        Ssh ssh = new Ssh(address, port, tracker.getConnectionTimeout());
        ssh.setClientBanner(clientBanner);

        RE regex = null;
        try {
	        if (match == null && (banner == null || banner.equals("*"))) {
	            regex = null;
	        } else if (match != null) {
	            regex = new RE(match);
	        } else if (banner != null) {
	            regex = new RE(banner);
	        }
        } catch (final RESyntaxException e) {
        	final String matchString = match == null? banner : match;
        	LogUtils.infof(this, "Invalid regular expression for SSH banner match /%s/: %s", matchString, e.getMessage());
        	LogUtils.debugf(this, e, "Invalid Regular expression for SSH banner match /%s/", matchString);
        }

        for (tracker.reset(); tracker.shouldRetry() && !ps.isAvailable(); tracker.nextAttempt()) {
            try {
                ps = ssh.poll(tracker);
            } catch (final InsufficientParametersException e) {
                LogUtils.errorf(this, e, "An error occurred polling host '%s'", address);
                break;
            }

            if (!ps.isAvailable()) {
                // not able to connect, retry
                continue;
            }

            // If banner matching string is null or wildcard ("*") then we
            // only need to test connectivity and we've got that!

            if (regex == null) {
                return ps;
            } else {
                String response = ssh.getServerBanner();

                if (response == null) {
                    return PollStatus.unavailable("server closed connection before banner was received.");
                }

                if (regex.match(response)) {
                    LogUtils.debugf(this, "isServer: matching response=%s", response);
                    return ps;
                } else {
                    // Got a response but it didn't match... no need to attempt
                    // retries
                    LogUtils.debugf(this, "isServer: NON-matching response=%s", response);
                    return PollStatus.unavailable("server responded, but banner did not match '" + banner + "'");
                }
            }
        }
        return ps;        
    }

    /**
     * {@inheritDoc}
     *
     * Poll the specified address for service availability.
     * @see #poll(InetAddress, Map)
     */
    public PollStatus poll(MonitoredService svc, Map<String, Object> parameters) {
        NetworkInterface<InetAddress> iface = svc.getNetInterface();
        if (iface.getType() != NetworkInterface.TYPE_INET)
            throw new NetworkInterfaceNotSupportedException("Unsupported interface type, only TYPE_INET currently supported");
        InetAddress address = (InetAddress) iface.getAddress();

        return poll(address, parameters);
    }

}