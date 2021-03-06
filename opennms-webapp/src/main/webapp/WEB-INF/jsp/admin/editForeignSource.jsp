<%--
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

--%>

<%@ page contentType="text/html;charset=UTF-8" language="java"
	import="
	java.util.Map,
	org.opennms.netmgt.provision.support.PluginWrapper
	" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags/tree" prefix="tree" %>
<%@ taglib tagdir="/WEB-INF/tags/springx" prefix="springx" %>

<jsp:include page="/includes/header.jsp" flush="false">
	<jsp:param name="title" value="设备配置导入" /> 
	<jsp:param name="headTitle" value="设备配置导入" />
	<jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
	<jsp:param name="breadcrumb" value="<a href='admin/provisioningGroups.htm'>设备配置导入</a>" />
	<jsp:param name="breadcrumb" value="编辑外源定义" />
</jsp:include>

<h3>外源名称: ${fn:escapeXml(foreignSourceEditForm.foreignSourceName)}</h3>

<tree:form commandName="foreignSourceEditForm"> 

	<input type="hidden" id="foreignSourceName" name="foreignSourceName" value="${fn:escapeXml(foreignSourceEditForm.foreignSourceName)}"/> 
	<tree:actionButton label="Done" action="done" />

	<br />
	<br />
	
	<c:set var="showDelete" value="false" scope="request" />
	<tree:nodeForm>
    	<tree:field label="扫描时间间隔" property="scanInterval" />
    </tree:nodeForm>
	<c:set var="showDelete" value="true" scope="request" />
    
	<h4>
		探测器 <tree:actionButton label="添加探测器" action="addDetector" />
	</h4>

	<tree:tree root="${foreignSourceEditForm.formData}" childProperty="detectors" var="detector" varStatus="detectorIter">
		<tree:nodeForm>
			<tree:field label="name" property="name" size="32" />
			<tree:select label="class" property="pluginClass" fieldSize="${classFieldWidth}" items="${detectorTypes}" />
			<c:if test="${!empty detector.availableParameterKeys}">
				<tree:action label="[添加参数]"  action="addParameter" />
			</c:if>
		</tree:nodeForm>

		<tree:tree root="${detector}" childProperty="parameters" var="parameter" varStatus="detectorParameterIter">
			<tree:nodeForm>
				<tree:select label="键" property="key" items="${parameter.availableParameterKeys}" fieldSize="24" />
				<tree:field label="值" property="value" size="96" />
			</tree:nodeForm>
		</tree:tree>
	</tree:tree>
	
	<h4>
		策略 <tree:actionButton label="添加策略" action="addPolicy" />
	</h4>

	<tree:tree root="${foreignSourceEditForm.formData}" childProperty="policies" var="policy" varStatus="policyIter">
	   <c:set var="showDelete" value="true" scope="request" />
		<tree:nodeForm>
			<tree:field label="name" property="name" size="32" />
			<tree:select label="类" property="pluginClass" fieldSize="${类FieldWidth}" items="${policyTypes}" />
			<c:if test="${!empty policy.availableParameterKeys}">
				<tree:action label="[添加参数]"  action="addParameter" />
			</c:if>
		</tree:nodeForm>

		<tree:tree root="${policy}" childProperty="parameters" var="parameter" varStatus="policyParameterIter">

			<c:choose>
				<c:when test="${pluginInfo[policy.pluginClass].required[parameter.key]}">
					<c:set var="showDelete" value="false" scope="request" />
					<tree:nodeForm>
						<tree:readOnlyField label="键" property="key" />
						<c:choose>
							<c:when test="${empty pluginInfo[policy.pluginClass].requiredItems[parameter.key]}">
						<tree:field label="值" property="value" size="96" />
							</c:when>
							<c:otherwise>
		                		<tree:select label="值" property="value" fieldSize="${valueFieldWidth}" items="${pluginInfo[policy.pluginClass].requiredItems[parameter.key]}" />
							</c:otherwise>
						</c:choose>
					</tree:nodeForm>
				</c:when>
				<c:otherwise>
					<c:set var="showDelete" value="true" scope="request" />
					<tree:nodeForm>
						<tree:select label="键" property="key" items="${parameter.availableParameterKeys}" fieldSize="24" />
				<tree:field label="值" property="value" size="96" />
					</tree:nodeForm>
				</c:otherwise>
			</c:choose>
			<c:set var="showDelete" value="true" scope="session" />

		</tree:tree>
	</tree:tree>
	  
</tree:form> 
<jsp:include page="/includes/footer.jsp" flush="false"/>
