/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2009-2012 The OpenNMS Group, Inc.
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

package org.opennms.core.soa.support;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNotSame;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.util.Set;

import org.junit.Test;
import org.opennms.core.soa.support.MultivaluedMap;
import org.opennms.core.soa.support.MultivaluedMapImpl;


/**
 * MultivaluedMapTest
 *
 * @author brozow
 */
public class MultivaluedMapTest {
    
    private MultivaluedMap<String, String> map = new MultivaluedMapImpl<String, String>();
    
    @Test
    public void testAddRemove() {
        
        String key = "key";
        String value1 = "value1";
        String value2 = "value2";
        
        assertNull(map.get(key));

        map.add(key, value1);
        map.add(key, value2);
        
        assertNotNull(map.get(key));
        
        assertEquals(2, map.get(key).size());
        
        assertTrue(map.get(key).contains(value1));
        assertTrue(map.get(key).contains(value2));
        
        assertTrue(map.remove(key, value1));
        
        assertEquals(1, map.get(key).size());
        
        assertFalse(map.get(key).contains(value1));
        assertTrue(map.get(key).contains(value2));
        
        assertTrue(map.remove(key, value2));

        assertNull(map.get(key));
        
        
    }
    
    @Test
    public void testGetCopy() {
        
        String key = "key";
        String value1 = "value1";
        String value2 = "value2";
        
        assertNull(map.get(key));

        map.add(key, value1);
        map.add(key, value2);

        Set<String> copy = map.getCopy(key);
        
        assertNotSame(copy, map.get(key));
        assertEquals(copy, map.get(key));
        
        
    }

}