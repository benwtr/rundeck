<%--
  Created by IntelliJ IDEA.
  User: greg
  Date: 10/4/13
  Time: 10:23 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="grails.converters.JSON; com.dtolabs.rundeck.server.authorization.AuthConstants" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

    <meta name="layout" content="base"/>
    <meta name="tabpage" content="home"/>
    <title><g:appTitle/></title>
    <g:embedJSON data="${projectNames}" id="projectNamesData"/>
    <asset:javascript src="menu/home.js"/>

</head>
<body>

<div class="row">
    <div class="col-sm-12">
        <g:render template="/common/messages"/>
    </div>
</div>
<div data-bind="if: projectCount()>0">
    <div class="row row-space">

        <div class="col-sm-4">
            <span class="h3 text-muted">
                <span data-bind="text: projectCount"></span>
                Projects
                %{--<g:plural code="Project" count="${projCount}" textOnly="${true}"/>--}%
            </span>
        </div>

        <div class="col-sm-4">
            <div data-bind="if: projectCount() > 1">
            %{--app summary info--}%
                <span class="h4">

                    <span class="summary-count"
                        data-bind="css: { 'text-info': execCount()>0, 'text-muted': execCount()<1 }">
                        <span data-bind="text: loaded()?execCount:''"></span>
                        <span data-bind="if: !loaded()" >...</span>
                    </span>
                    <strong>
                        Executions
                        %{--<g:plural code="Execution" count="${execCount}" textOnly="${true}"/>--}%
                    </strong>
                    In the last day
                </span>
                <div data-bind="if: recentProjectsCount()>1">
                    in
                    <span class="text-info" data-bind="text: recentProjectsCount()">

                    </span>

                    %{--<g:plural code="Project" count="${projectSummary?.size()}" textOnly="${true}"/>:--}%
                    Projects:
                    <span data-bind="foreach: recentProjects">
                        <a href="${g.createLink(action:'index',controller:'menu',params:[project:'<$>'])}"
                           data-bind="urlPathParam: $data, text: $data"></a>
                        %{--<g:link action="index" controller="menu" params="[project: '$']" --}%
                                %{--data-bind="text: $data,">--}%
                            %{----}%
                        %{--</g:link>--}%
                    </span>
                    <g:each var="project" in="${projectSummary?.sort()}" status="i">
                        <g:link action="index" controller="menu" params="[project: project]">
                            <g:enc>${project}</g:enc></g:link><g:if test="${i < projectSummary.size() - 1}">,</g:if>
                    </g:each>
                </div>
                <div data-bind="if: recentUsersCount()>0">
                        by
                        <span class="text-info" data-bind="text: recentUsersCount">

                        </span>
                        users:
                        %{--<g:plural code="user" count="${userCount}" textOnly="${true}"/>:--}%
                        <span data-bind="text: recentUsers().join(', ')">

                        </span>
                        %{--<g:each in="${userSummary}" var="user" status="i">--}%
                            %{--<g:enc>${user}</g:enc><g:if test="${i < userSummary.size() - 1}">,</g:if>--}%
                        %{--</g:each>--}%
                </div>
            </div>
        </div>
        <auth:resourceAllowed action="create" kind="project" context="application">
            <div class="col-sm-4">
                <g:link controller="framework" action="createProject" class="btn  btn-success pull-right">
                    New Project
                    <b class="glyphicon glyphicon-plus"></b>
                </g:link>
            </div>
        </auth:resourceAllowed>
    </div>
</div>
<div data-bind="if: projectCount()<1">
    <div class="row row-space">
        <div class="col-sm-12">
            <auth:resourceAllowed action="create" kind="project" context="application" has="false">
                <div class="well">
                    <g:set var="roles" value="${request.subject?.getPrincipals(com.dtolabs.rundeck.core.authentication.Group.class)?.collect { it.name }?.join(", ")}"/>
                    <h2 class="text-warning">
                        <g:message code="no.authorized.access.to.projects" />
                    </h2>
                    <p>
                        <g:message code="no.authorized.access.to.projects.contact.your.administrator.user.roles.0" args="[roles]" />
                    </p>
                </div>
            </auth:resourceAllowed>
            <auth:resourceAllowed action="create" kind="project" context="application" has="true">
                <div class="jumbotron">
                    <h1>Welcome to <g:appTitle/></h1>

                    <p>
                        To get started, create a new project.
                    </p>
                    <p>
                        <g:link controller="framework" action="createProject" class="btn  btn-success btn-lg ">
                            New Project
                            <b class="glyphicon glyphicon-plus"></b>
                        </g:link>
                    </p>
                </div>
            </auth:resourceAllowed>
        </div>
    </div>
</div>

<div class="row row-space">
    <div class="col-sm-12">
        <div class="list-group">
            <div data-bind="foreach: { data: projectNames(), as: 'project' } ">
            %{--Template for project details--}%
                <div class="list-group-item">
                    <div class="row">
                        <div class="col-sm-6 col-md-4">
                            <a href="${g.createLink(action:'index',controller:'menu',params:[project:'<$>'])}"
                                data-bind="urlPathParam: project"
                               class="h3">
                                <i class="glyphicon glyphicon-tasks"></i>
                                <span data-bind="text: project"></span>
                            </a>

                            <span data-bind="if: $root.projectForName(project)">
                                <span class="text-muted" data-bind="text: $root.projectForName(project).description"></span>
                            </span>
                            %{--<g:if test="${data.description}">--}%
                                %{--<span class="text-muted"><g:enc>${data.description}</g:enc></span>--}%
                            %{--</g:if>--}%
                        </div>

                        <div class="clearfix visible-sm"></div>
                        <div class="col-sm-6 col-md-4">
                            <span data-bind="if: $root.projectForName(project)">
                            <a class="h4"
                                data-bind="css: { 'text-muted': $root.projectForName(project).execCount()<1 } "
                                href="#"
                               %{--href="${g.createLink(controller: "reports", action: "index", params: [project: project])}"--}%

                            >
                                <span class="summary-count "
                                      data-bind="css: { 'text-muted': $root.projectForName(project).execCount()<1, 'text-info':$root.projectForName(project).execCount()>0 } "
                                >
                                        <span data-bind="text: $root.projectForName(project).loaded()?$root.projectForName(project).execCount():''"></span>
                                        <span data-bind="if: !$root.projectForName(project).loaded()" >...</span>
                                </span>
                                <strong>
                                    Executions
                                    %{--<g:plural code="Execution" count="${data.execCount}" textOnly="${true}"/>--}%
                                </strong>
                                In the last day
                            </a>
                            <div>
                                <div data-bind="if: $root.projectForName(project).userCount()>0">
                                    by
                                    <span class="text-info" data-bind="text: $root.projectForName(project).userCount()">
                                    </span>

                                    users
                                    %{--<g:plural code="user" count="${data.userCount}" textOnly="${true}"/>:--}%


                                    <span data-bind="text: $root.projectForName(project).userSummary().join(', ')">

                                    </span>
                                </div>
                            </div>
                            </span>
                        </div>



                        <div class="clearfix visible-xs visible-sm"></div>
                        <div data-bind="if: $root.projectForName(project)">

                            <div class="col-sm-12 col-md-4" data-bind="if: $root.projectForName(project).auth">
                                <div class="pull-right">
                                    <span data-bind="if: $root.projectForName(project).auth.admin">
                                        <a href="${g.createLink(controller: "menu", action: "admin", params: [project: '<$>'])}"
                                            data-bind="urlPathParam: project"
                                           class="btn btn-default btn-sm">
                                            <g:message code="gui.menu.Admin"/>
                                        </a>
                                    </span>
                                    <div class="btn-group " data-bind="if: $root.projectForName(project).auth.jobCreate">

                                            <button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown">
                                                Create <g:message code="domain.ScheduledExecution.title"/>
                                                <span class="caret"></span>
                                            </button>
                                            <ul class="dropdown-menu pull-right" role="menu">
                                                <li><a href="${g.createLink(controller: "scheduledExecution", action: "create", params: [project: '<$>'])}"
                                                       data-bind="urlPathParam: project"
                                                >
                                                    <i class="glyphicon glyphicon-plus"></i>
                                                    New <g:message
                                                        code="domain.ScheduledExecution.title"/>&hellip;

                                                </a>
                                                </li>
                                                <li class="divider">
                                                </li>
                                                <li>
                                                    <a href="${g.createLink(controller: "scheduledExecution", action: "upload", params: [project: '<$>'])}"
                                                       data-bind="urlPathParam: project"
                                                       class="">
                                                        <i class="glyphicon glyphicon-upload"></i>
                                                        Upload Definition&hellip;
                                                    </a>
                                                </li>
                                            </ul>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div data-bind="if: $root.projectForName(project)">
                        <div class="row row-space" data-bind="if: $root.projectForName(project).readme && ($root.projectForName(project).readme.readmeHTML || $root.projectForName(project).readme.motdHTML)">
                            <div class="col-sm-12">
                                <div data-bind="if: $root.projectForName(project).readme.motd">
                                %{--Test if user has dismissed the motd for this project--}%
                                    <span data-bind="if: $root.projectForName(project).readme.motdHTML">
                                        %{--<g:enc raw="true">${data.readme.motdHTML}</g:enc>--}%
                                        <span data-bind="html: $root.projectForName(project).readme.motdHTML()"></span>
                                    </span>
                                    %{--<span data-bind="if: $root.projectForName(project).readme.motd">--}%
                                        %{--<span data-bind="text: $root.projectForName(project).readme.motd()"></span>--}%
                                    %{--</span>--}%
                                </div>
                                <div data-bind="if: $root.projectForName(project).readme.readme">
                                    <span data-bind="if: $root.projectForName(project).readme.readmeHTML">
                                        <span data-bind="html: $root.projectForName(project).readme.readmeHTML()"></span>
                                    </span>
                                    %{--<span data-bind="if: $root.projectForName(project).readme.readme">--}%
                                        %{--<span data-bind="text: $root.projectForName(project).readme.readme()"></span>--}%
                                    %{--</span>--}%

                                </div>

                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

</body>
</html>
