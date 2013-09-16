<g:set var="timeNow" value="${new Date().getTime()}"/>
<%
    def runcount = 0;
%>
<g:if test="${executions?.size()>0}">
        <% def j = 0 %>
        <g:each in="${executions}" var="execution">
            <g:set var="scheduledExecution" value="${jobs[execution.scheduledExecution?.id.toString()]}"/>
            <g:set var="execstatus" value="${execution.dateCompleted?(execution.status=='true'?'succeeded':execution.cancelled?'killed':'failed'):'alive'}"/>

            <g:set var="execLink" value="${createLink(controller:'execution',action:'show', id:execution.id)}"/>

            <tr class=" ${j % 2 == 1 ? 'alternateRow' : ''}  ${!execution.dateCompleted ? 'nowrunning' : ''} execution ${execstatus} link"
                id="${upref}exec-${execution.id}-row" onclick="document.location='${execLink}';">
                <g:set var="fileName" value="job"/>
                %{--<g:if test="${execution}">--}%
                %{--<g:set var="fileName"--}%
                       %{--value="${execution.status == 'true' ? 'job-ok' : null == execution.dateCompleted ? 'job-running' : execution.cancelled ? 'job-warn' : 'job-error'}"/>--}%
                %{--</g:if>--}%
                <td style="width:12px;" class="eventicon">
                %{--<g:if test="${!noimgs}"><img--}%
                        %{--src="${resource(dir: 'images', file: "icon-small-" + fileName + ".png")}"--}%
                        %{--alt="job" style="border:0;" width="12px" height="12px"/></g:if>--}%
                <g:set var="gicon"
                       value="${execution.status == 'true' ? 'ok-circle' : null == execution.dateCompleted ? 'play-circle' : execution.cancelled ? 'minus-sign' : 'warning-sign'}"/>

                <i class="glyphicon glyphicon-${gicon} exec-status ${!execution.dateCompleted?'running':execution.status == 'true' ? 'succeed' : execution.cancelled ? 'warn' : 'fail'}">
                </i>

                </td>
                <g:if test="${scheduledExecution}">
                    <td class=" eventtitle job">

                        #${execution.id}
                        ${scheduledExecution.groupPath ? scheduledExecution.groupPath + '/' : ''}${scheduledExecution.jobName.encodeAsHTML()}
                    </td>

                    <td class="eventargs">
                        <g:if test="${execution && execution.argString}">
                            ${execution.argString.encodeAsHTML()}
                        </g:if>
                    </td>
                </g:if>
                <g:else>
                    <td class="jobname adhoc ">
                        #${execution.id}
                        ${execution.workflow.commands[0].adhocRemoteString.encodeAsHTML()}
                    </td>
                    <td class="eventargs">
                    </td>
                </g:else>

                <g:if test="${!small}">
                    <td class="dateStarted date " title="started: ${execution.dateStarted}">
                        <span class="timelabel">at:</span>
                        <span class="timeabs"><g:relativeDate atDate="${execution.dateStarted}"/></span>
                        <em>by</em>
                        <g:username user="${execution.user}"/>
                    </td>
                </g:if>

                <td class="runstatus " style="width:200px" colspan="2">

                    <g:if test="${execution.dateCompleted}">
                        <span class="timelabel" title="completed: ${execution.dateCompleted}">
                            <g:if test="${execution.status=='true'}">
                                completed:
                            </g:if>
                            <g:elseif test="${execution.cancelled}">
                                killed:
                            </g:elseif>
                            <g:else>
                                failed:
                            </g:else>
                        </span>
                        <span class="completedTime" title="completed: ${execution.dateCompleted}">
                            <g:relativeDate atDate="${execution.dateCompleted}"/>
                        </span>
                        <span class=" duration">
                            <g:if test="${!small}">
                                <span class="timelabel">duration:</span>
                            </g:if>
                            (${execution.durationAsString()})
                        </span>
                    </g:if>
                    <g:else>
                        <g:if test="${scheduledExecution && scheduledExecution.execCount>0 && scheduledExecution.totalTime > 0 && execution.dateStarted}">
                            <g:set var="avgTime" value="${(Long)(scheduledExecution.totalTime/scheduledExecution.execCount)}"/>
                            <g:set var="completePercent" value="${(int)Math.floor((double)(100 * (timeNow - execution.dateStarted.getTime())/(avgTime)))}"/>
                            <g:set var="estEndTime" value="${(long)(execution.dateStarted.getTime() + (long)avgTime)}"/>
                            <g:set var="completeEstimate" value="${new Date(estEndTime)}"/>
                            <g:set var="completeEstimateTime" value="${g.relativeDate(atDate:completeEstimate)}"/>
                            <g:if test="${estEndTime>timeNow}">
                                <g:set var="completeRemaining" value="${g.timeDuration(start:new Date(timeNow),end:completeEstimate)}"/>
                            </g:if>
                            <g:else>
                                <g:set var="completeRemaining" value="${'+'+g.timeDuration(start:completeEstimate,end:new Date(timeNow))}"/>
                            </g:else>
                            <g:render template="/common/progressBar"
                                      model="${[completePercent:(int)completePercent,
                                              title:completePercent < 100 ? 'Estimated completion time: ' + completeEstimateTime : '',
                                              progressClass: 'rd-progress-exec progress-striped',
                                              progressBarClass: 'progress-bar-info',
                                showpercent:true,showOverrun:true,remaining:' ('+completeRemaining+')',width:120]}"/>
                        </g:if>
                        <g:else>
                            <g:render template="/common/progressBar" model="${[
                                    indefinite:true,title:'Running',innerContent:'Running',width:120,
                                    progressClass: 'rd-progress-exec progress-striped active indefinite',
                                    progressBarClass: 'progress-bar-info',
                            ]}"/>
                        </g:else>
                    </g:else>
                </td>

                <td class="outputlink hilite action ${!execution.dateCompleted ? 'nowrunning' : ''}">
                    <g:link title="View execution output" controller="execution" action="show" id="${execution.id}" class="_defaultAction">Show &raquo;</g:link>
                </td>

            </tr>
            <% j++ %>

        </g:each>
</g:if>
<g:else>
    <g:if test="${emptyText}">
    <span class="note empty">${emptyText}</span>
    </g:if>
</g:else>
<script language="text/javascript">
    if (typeof(updateNowRunning) == 'function') {
        updateNowRunning(<%=executions?.size()%>);
    }
</script>
