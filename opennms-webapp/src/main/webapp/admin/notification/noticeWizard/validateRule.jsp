<%--
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

--%>

<%@page language="java"
	contentType="text/html"
	session="true"
	import="java.util.*,
		java.net.InetAddress,
		org.opennms.core.utils.InetAddressUtils,
		org.opennms.web.admin.notification.noticeWizard.*,
		org.opennms.web.api.Util,
        org.opennms.netmgt.filter.FilterDaoFactory,
		org.opennms.netmgt.filter.FilterParseException,
		org.opennms.netmgt.config.notifications.*
	"
%>

<%!
    public void init() throws ServletException {
        try {
        }
        catch( Exception e ) {
            throw new ServletException( "Cannot load configuration file", e );
        }
    }
%>

<% HttpSession user = request.getSession(true);
   Notification newNotice = (Notification)user.getAttribute("newNotice");
   String newRule = (String)request.getParameter("newRule");
   String services[] = request.getParameterValues("services");
   if (services==null)
      services = new String[0];
   String notServices[] = request.getParameterValues("notServices");
   if (notServices==null)
      notServices = new String[0];
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="验证规则" />
  <jsp:param name="headTitle" value="验证规则" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/index.jsp'>配置通知</a>" />
  <jsp:param name="breadcrumb" value="验证规则" />
</jsp:include>

<script type="text/javascript" >
  
  function next()
  {
      document.addresses.userAction.value="next";
      document.addresses.submit();
  }
  
  function rebuild()
  {
      document.addresses.userAction.value="rebuild";
      document.addresses.submit();
  }
  
</script>

<h2><%=(newNotice.getName()!=null ? "Editing notice: " + newNotice.getName() + "<br/>" : "")%></h2>

<h3>检查TCP/IP地址，以确保该规则已获得预期的结果。
          如果不相符点击表格下面的"重建"链接。如果结果看起来正常继续点击表格下面"下一步"链接。</h3>
      <table width="100%" cellspacing="0" cellpadding="0" border="0">
        <tr>
          <td width="10%">当前规则:
          </td>
          <td align="left"> <%=newRule%>
          </td>
      </table>
      <br/>
      <form method="post" name="addresses" action="admin/notification/noticeWizard/notificationWizard">
        <%=Util.makeHiddenTags(request)%>
        <input type="hidden" name="userAction" value=""/>
        <input type="hidden" name="sourcePage" value="<%=NotificationWizardServlet.SOURCE_PAGE_VALIDATE%>"/>
        <table width="25%" cellspacing="2" cellpadding="2" border="1">
          <tr bgcolor="#999999">
            <td width="50%">
              <b>接口</b>
            </td>
            <td width="50%">
              <b>与接口相关的服务</b>
            </td>
          </tr>
          <%=buildInterfaceTable(newRule, services, notServices)%>
        </table>
        <table width="100%" cellspacing="2" cellpadding="2" border="0">
         <tr> 
          <td>
           <a HREF="javascript:rebuild()">&#139;&#139;&#139; 重建</a>&nbsp;&nbsp;&nbsp;
           <a HREF="javascript:next()">下一步 &#155;&#155;&#155;</a>
          </td>
        </tr>
        </table>
      </form>

<jsp:include page="/includes/footer.jsp" flush="false" />

<%!
  public String buildInterfaceTable(String rule, String[] serviceList, String[] notServiceList)
      throws FilterParseException
  {
          StringBuffer buffer = new StringBuffer();
          // TODO: BUG 2009: Also list node names for each IP address that is selected by the
          // filter?
          
          final Map<InetAddress, Set<String>> interfaces = FilterDaoFactory.getInstance().getIPAddressServiceMap(rule);
          
          for (final InetAddress key : interfaces.keySet()) {
              buffer.append("<tr><td width=\"50%\" valign=\"top\">").append(InetAddressUtils.str(key)).append("</td>");
              buffer.append("<td width=\"50%\">");
              
              if (serviceList.length!=0 || notServiceList.length!=0) {
                  for (String service : interfaces.get(key)) { 
                      buffer.append(service).append("<br/>");
                  }
              } else {
                  buffer.append("All services");
              }
              
              buffer.append("</td>");
                  
              buffer.append("</tr>");
          }
          
          return buffer.toString();
  }
%>