<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
    <title>综合管理系统</title>
	<meta charset="utf-8">
    <script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.cookie.js" type="text/javascript"></script>
    <script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/js/changeEasyuiTheme.js" type="text/javascript"></script>
    <script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/outlook2.js"> </script>
    <link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
    <link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
    <link href="<%=request.getContextPath()%>/css/default.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
	
	 	var _menus = {
		     "menus":[
		     	{"menuid":"1","icon":"icon-sys","menuname":"订单管理",
					"menus":[
						{"menuid":"12","menuname":"订单录入","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/order/order_entering_list.jsp"},
						{"menuid":"13","menuname":"订单审批","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/order/order_approval_list.jsp"},
					]
		     	},
				{"menuid":"8","icon":"icon-sys","menuname":"生产计划管理",
							"menus":[{"menuid":"21","menuname":"生产计划录入","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/productionPlan/production_plan_entering_list.jsp"},
									{"menuid":"22","menuname":"生产计划审批","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/productionPlan/production_plan_approval_list.jsp"}
								]
				},
				{"menuid":"56","icon":"icon-sys","menuname":"设计管理",
							"menus":[{"menuid":"31","menuname":"设计方案录入","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/design/design_entering_list.jsp"},
									{"menuid":"32","menuname":"设计方案审批","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/design/design_approval_list.jsp"}
								]
				},
				{"menuid":"28","icon":"icon-sys","menuname":"收款发货管理",
							"menus":[{"menuid":"41","menuname":"收款单录入","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/gatherAndShipments/gathering_entering_list.jsp"},
									{"menuid":"42","menuname":"收款单审批","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/gatherAndShipments/gathering_approval_list.jsp"},
									{"menuid":"43","menuname":"发货申请单录入","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/gatherAndShipments/shipments_entering_list.jsp"},
									{"menuid":"44","menuname":"发货申请单审批","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/gatherAndShipments/shipments_approval_list.jsp"},
									{"menuid":"45","menuname":"送货单录入","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/gatherAndShipments/delivery_entering_list.jsp"},
									{"menuid":"46","menuname":"物流情况录入","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/gatherAndShipments/logistics_entering_list.jsp"}
								]
				},
				{"menuid":"39","icon":"icon-sys","menuname":"采购管理",
							"menus":[{"menuid":"51","menuname":"采购计划录入","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/procurementPlan/procurement_plan_entering_list.jsp"},
									{"menuid":"52","menuname":"采购计划审批","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/procurementPlan/procurement_plan_approval_list.jsp"},
									{"menuid":"53","menuname":"采购订单录入","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/procurementPlan/procurement_order_entering_list.jsp"},
									{"menuid":"54","menuname":"采购订单审批","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/procurementPlan/procurement_order_approval_list.jsp"},
									{"menuid":"55","menuname":"验收确认","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/procurementPlan/procurement_acceptance_list.jsp"},
									{"menuid":"56","menuname":"付款申请单录入","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/procurementPlan/payment_request_entering_list.jsp"},
									{"menuid":"57","menuname":"付款申请单审批","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/procurementPlan/payment_request_approval_list.jsp"}
								]
				},
				{"menuid":"50","icon":"icon-sys","menuname":"仓库管理",
					"menus":[{"menuid":"61","menuname":"入库","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/entrepot/entrepot_entering_list.jsp"},
							{"menuid":"62","menuname":"出库","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/entrepot/entrepot_outing_list.jsp"},
							{"menuid":"63","menuname":"库存查询","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/entrepot/entrepot_query.jsp"},
							{"menuid":"64","menuname":"库存量预警设置","icon":"icon-nav","url":"<%=request.getContextPath()%>/app/entrepot/entrepot_num_set.jsp"}
						]
				},
				{"menuid":"50","icon":"icon-sys","menuname":"系统管理",
					"menus":[{"menuid":"71","menuname":"模块管理","icon":"icon-nav","url":"demo.html"},
							{"menuid":"72","menuname":"部门管理","icon":"icon-nav","url":"demo1.html"},
							{"menuid":"73","menuname":"角色管理","icon":"icon-nav","url":"demo2.html"},
							{"menuid":"74","menuname":"用户管理","icon":"icon-nav","url":"demo2.html"},
							{"menuid":"75","menuname":"单位设置","icon":"icon-nav","url":"demo2.html"}
						]
				}
				
				]};
        //设置登录窗口
        function openPwd() {
            $('#w').window({
                title: '修改密码',
                width: 300,
                modal: true,
                shadow: true,
                closed: true,
                height: 160,
                resizable:false
            });
        }
        //关闭登录窗口
        function closePwd() {
            $('#w').window('close');
        }

        

        //修改密码
        function serverLogin() {
            var $newpass = $('#txtNewPass');
            var $rePass = $('#txtRePass');

            if (strIsNull($newpass.val())) {
                msgShow('系统提示', '请输入密码！', 'warning');
                return false;
            }
            if (strIsNull($rePass.val())) {
                msgShow('系统提示', '请在一次输入密码！', 'warning');
                return false;
            }

            if ($newpass.val() != $rePass.val()) {
                msgShow('系统提示', '两次密码不一至！请重新输入', 'warning');
                return false;
            }

            $.post('<%=request.getContextPath()%>/login/modifypwd?newpass=' + $newpass.val(), function(msg) {
                msgShow('系统提示', '恭喜，密码修改成功！', 'info');
                $newpass.val('');
                $rePass.val('');
                closePwd();
            })
            
        }

        	
      //判断字符串是否为空字符串  空返回true
		function strIsNull(str){
			var flag = true;
			for(i=0;i<str.length;i++){
				if(str.charAt(i) != ' '){
					flag = false;
					break;
				}
			}
			return flag;
		}
        
        $(function() {

            openPwd();

            $('#editpass').click(function() {
                $('#w').window('open');
            });

            $('#btnEp').click(function() {
                serverLogin();
            })

			$('#btnCancel').click(function(){closePwd();})

            $('#loginOut').click(function() {
                $.messager.confirm('系统提示', '您确定要退出本次登录吗?', function(r) {

                    if (r) {
                        location.href = '<%=request.getContextPath()%>/login/logout';
                    }
                });
            })
            
            //加载菜单栏
            $.ajax({
            	url:"<%=request.getContextPath()%>/sys/getSysMenus",
				type:"post",
				dataType:"json",
				success:function(data, textStatus){
					$("#nav").accordion({animate:false});//为id为nav的div增加手风琴效果，并去除动态滑动效果
				    $.each(data, function(i, n) {//$.each 遍历_menu中的元素
						var menulist ='';
						menulist +='<ul>';
				        $.each(n.childs, function(j, o) {
							menulist += '<li><div><a ref="'+o.id+'" href="#" rel="<%=request.getContextPath()%>' + o.uri + '" ><span class="icon icon-nav" >&nbsp;</span><span class="nav">' + o.name + '</span></a></div></li> ';
				        })
						menulist += '</ul>';

						$('#nav').accordion('add', {
				            title: n.name,
				            content: menulist,
				            iconCls: 'icon icon-sys'
				        });

				    });

					$('.easyui-accordion li a').click(function(){//当单击菜单某个选项时，在右边出现对用的内容
						var tabTitle = $(this).children('.nav').text();//获取超链里span中的内容作为新打开tab的标题

						var url = $(this).attr("rel");
						var menuid = $(this).attr("ref");//获取超链接属性中ref中的内容
						var icon = "icon icon-nav";
						addTab(tabTitle,url,icon);//增加tab
						$('.easyui-accordion li div').removeClass("selected");
						$(this).parent().addClass("selected");
					}).hover(function(){
						$(this).parent().addClass("hover");
					},function(){
						$(this).parent().removeClass("hover");
					});

					//选中第一个
					var panels = $('#nav').accordion('panels');
					var t = panels[0].panel('options').title;
				    $('#nav').accordion('select', t);
				},
				async:true
            });
            
            //加载待办事项
            $.ajax({
            	url:'<%=request.getContextPath()%>/sys/getToDo',
            	type:'post',
            	dataType:'json',
            	success:function(data){
            		var html = "";
            		for(i=0;i<data.length;i++){
            			html += "<tr><td><a style=\"font-size: 16px; font-weight: 2; color:red;\" href=\"javascript:addTab('" + data[i].title + "','" + data[i].url + "','" + data[i].icon + "')\">";
            			html += data[i].name + "！";
            			html += "</a></td></tr>";
            		}
            		$('#todoTable').append(html);
            	},
            	async:true
            });
        });
		
		
    </script>
    </head>
    <body class="easyui-layout" style="overflow-y: hidden"  scroll="no">
		<noscript>
    		<div style=" position:absolute; z-index:100000; height:2046px;top:0px;left:0px; width:100%; background:white; text-align:center;"> <img src="images/noscript.gif" alt='抱歉，请开启脚本支持！' /> </div>
    	</noscript>
		<div region="north" split="true" border="false" style="overflow: hidden; height: 30px;
        		background: url(images/layout-browser-hd-bg.gif) #7f99be repeat-x center 50%;
        		line-height: 20px;color: #fff; font-family: Verdana, 微软雅黑,黑体"> 
        	<span style="float:right; padding-right:20px;" class="head">
        		欢迎 ${login_user.realname}
        		<a href="#" id="editpass">修改密码</a> <a href="#" id="loginOut">安全退出</a>
        	</span> 
        	<span style="padding-left:10px; font-size: 16px; ">
        		<img src="images/blocks.gif" width="20" height="20" align="absmiddle" />
        		综合管理系统
        	</span> 
        </div>
		<div region="south" split="true" style="height: 30px; background: #D2E0F2; ">
      		<div class="footer">版权所有:武汉大通窑炉机械设备有限公司</div>
    	</div>
		<div region="west" hide="true" split="true" title="系统菜单" style="width:180px;" id="west">
      		<div id="nav" class="easyui-accordion" fit="false" border="false"> 
    		<!--  导航内容 --> 
    		</div>
    	</div>
		<div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
      		<div id="tabs" class="easyui-tabs"  fit="true" border="false" >
      			<div title="欢迎使用" style="padding:20px;overflow:hidden; color:red; " >
    				<table id="todoTable">
	      				<tr>
	      					<td style="font-size: 35px; font-weight: 3;">待办事项</td>
	      				</tr>
      				</table>
      				<!--
          			<h1 style="font-size:24px;">欢迎使用综合管理系统</h1>
          			-->
        		</div>
  			</div>
    	</div>

		<!--修改密码窗口-->
		<div id="w" class="easyui-window" title="修改密码" collapsible="false" minimizable="false"
        		maximizable="false" icon="icon-save"  style="width: 350px; height: 150px; padding: 5px;
        		background: #fafafa;">
      		<div class="easyui-layout" fit="true">
    			<div region="center" border="false" style="padding: 10px; background: #fff; border: 1px solid #ccc;">
          			<table cellpadding=3>
        				<tr>
              				<td>新密码：</td>
              				<td><input id="txtNewPass" type="Password" class="txt01" /></td>
            			</tr>
        				<tr>
              				<td>确认密码：</td>
              				<td><input id="txtRePass" type="Password" class="txt01" /></td>
            			</tr>
      				</table>
        		</div>
    			<div region="south" border="false" style="text-align: right; height: 30px; line-height: 30px;"> 
    				<a id="btnEp" class="easyui-linkbutton" icon="icon-ok" href="javascript:void(0)" > 确定</a> 
    				<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" href="javascript:void(0)">取消</a> 
    			</div>
  			</div>
    	</div>
		<div id="mm" class="easyui-menu" style="width:150px;">
      		<div id="mm-tabupdate">刷新</div>
      		<div class="menu-sep"></div>
      		<div id="mm-tabclose">关闭</div>
      		<div id="mm-tabcloseall">全部关闭</div>
      		<div id="mm-tabcloseother">除此之外全部关闭</div>
      		<div class="menu-sep"></div>
      		<div id="mm-tabcloseright">当前页右侧全部关闭</div>
      		<div id="mm-tabcloseleft">当前页左侧全部关闭</div>
      		<div class="menu-sep"></div>
      		<div id="mm-exit">退出</div>
    	</div>
	</body>
</html>
