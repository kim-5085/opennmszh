/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2007-2014 The OpenNMS Group, Inc.
 * OpenNMS(R) is Copyright (C) 1999-2014 The OpenNMS Group, Inc.
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

package org.opennms.netmgt.jetty.jmx;

import org.opennms.netmgt.daemon.BaseOnmsMBean;

/**
 * <p>JettyServerMBean interface.</p>
 *
 * @author ranger
 * @version $Id: $
 */
public interface JettyServerMBean extends BaseOnmsMBean {

    /**
     * 
     * @return The total number of HTTPS connections since the JettyServer
     *         was started
     */
    public long getHttpsConnectionsTotal();
    
    /**
     * 
     * @return The current number of HTTPS connections to the JettyServer
     */
    public long getHttpsConnectionsOpen();
    
    /**
     * 
     * @return The maximum number of concurrent HTTPS connections to
     *         the JettyServer since it was started
     */
    public long getHttpsConnectionsOpenMax();

    /**
     * 
     * @return The total number of plain-HTTP connections since the
     *         JettyServer was started
     */
    public long getHttpConnectionsTotal();
    
    /**
     * 
     * @return The current number of plain-HTTP connections to the
     *         JettyServer
     */
    public long getHttpConnectionsOpen();

    /**
     *  
     * @return The maximum number of concurrent plain-HTTP connections
     *         to the JettyServer since it was started
     */
    public long getHttpConnectionsOpenMax();
    
}