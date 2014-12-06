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
    <link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
	<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
	<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/outlook2.js"> </script>
    <script type="text/javascript">
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
        	// extend the 'equals' rule
        	$.extend($.fn.validatebox.defaults.rules, {
        	    equals: {
        	        validator: function(value,param){
        	            return value == $(param[0]).val();
        	        },
        	        message: '两次输入的密码不一致'
        	    }
        	});
        	
        	$('#tt').tree({
        	    url:'<%=request.getContextPath()%>/sys/getDeptTree',
        	    onClick: function(node){
        	    	$('#pid').val(node.id);
        			$('#userList').datagrid({url:'<%=request.getContextPath()%>/sys/getUsersByDeptId?deptId=' + node.id});
        		}
        	});
        	
        	$('#userList').datagrid({
        		url:'<%=request.getContextPath()%>/sys/getUsersByDeptId?deptId=1',
    			title: '用户列表',
    			toolbar:[
    			    {iconCls : 'icon-add', 
    			     text : '新增', 
					 handler: 
					 	function(){
						 	$('#addDept').combotree({
						 		url:'<%=request.getContextPath()%>/sys/getDeptTree',
						 		required: true
						 	});
						 	
						 	$('#addDept').combotree('setValue', $('#pid').val());
						 
							$('#addWin').window('open');
						}
					},
					{iconCls : 'icon-edit', 
	    			 text : '编辑', 
					 handler: 
					 	function(){
						 	var data = $('#userList').datagrid('getSelected');
			
						 	if(data==null){
						 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
						 		return;
						 	}
						 	
						 	$('#id').val(data.id);
						 	
						 	$('#editStatus').combobox({
						 		data:[{'id':0, 'text':'有效'},{'id':1, 'text':'失效'}],
						 		valueField:'id',
						 		textField:'text',
						 		required: true
						 	});
						 	$('#editStatus').combobox('select', data.isdisable);
						 	
						 	$('#editRealname').val(data.realname);
						 	$('#editEmail').val(data.email);
						 	
						 	$('#editDept').combotree({
						 		url:'<%=request.getContextPath()%>/sys/getDeptTree',
						 		required: true
						 	});
						 	
						 	$('#editDept').combotree('setValue', data.deptId);
						 	
							$('#editWin').window('open');
						}
					},
					{iconCls : 'icon-ok', 
		    			 text : '角色', 
						 handler: 
						 	function(){
							 	var data = $('#userList').datagrid('getSelected');
								if(data==null){
							 		msgShow('提示', '请选中需要编辑角色的管理员' , 'warning');
							 		return;
							 	}
								$('#role_userId').val(data.id);
								
								$('#roleList').datagrid({
					        		url:'<%=request.getContextPath()%>/sys/getUserRoleList?selectUser=' + data.id,
					    			fitColumns: true,
					    			striped: true,
					    			singleSelect:false,
					    			rownumbers:true,
					    			columns:[[
					    			    {field:'id', checkbox:true},
					    				{field:'name',title:'角色名称',width:80},
					    				{field:'code',title:'角色编码',width:80},
					    				{field:'sdesc',title:'角色描述',width:80}
					    			]],
					    			onLoadSuccess:function(data){                   
					    				if(data){
					    					$.each(data.rows, function(index, item){
					    						if(item.isHas){
					    							$('#roleList').datagrid('checkRow', index);
					    						}
					    					});
					    				}
					    			}    
					    		});
								$('#roleWin').window('open');
							}
					},
					{iconCls : 'icon-reload', 
		    			 text : '重置密码', 
						 handler: 
						 	function(){
							 	var data = $('#userList').datagrid('getSelected');
				
							 	if(data==null){
							 		msgShow('提示', '请选中需要重置密码的数据' , 'warning');
							 		return;
							 	}
							 	
							 	$('#pwdId').val(data.id);
							 	$('#salt').val(data.salt);
								$('#pwdWin').window('open');
							}
						}
    			],
    			fitColumns: true,
    			striped: true,
    			singleSelect:true,
    			rownumbers:true,
    			pagination:true,
    			columns:[[
					{field:'id',title:'ID',width:80},
					{field:'username',title:'用户名',width:80},
    				{field:'realname',title:'姓名',width:80},
    				{field:'email',title:'邮箱',width:80},
    				{field:'deptName',title:'所在部门',width:80},
    				{field:'isdisable',title:'状态',width:80, formatter:function(value, rowData, rowIndex){
    					return value==0?"有效":"失效";
    				}},
    			]]
    		});
        	
        	var p = $('#userList').datagrid('getPager'); 
    		p.pagination({  
    	        pageSize : 10,// 每页显示的记录条数，默认为20  
    	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
    	        beforePageText : '第',// 页数文本框前显示的汉字  
    	        afterPageText : '页    共 {pages} 页',  
    	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
    	    });
        	
        	$('#addWin').window({
                title: '新增',
                width: 520,
                modal: true,
                shadow: true,
                closed: true,
                height: 450,
            	left: (screen.width-800)/2,
            	top:(screen.height-750)/2
            });
        	
        	$('#editWin').window({
                title: '编辑',
                width: 520,
                modal: true,
                shadow: true,
                closed: true,
                height: 450,
            	left: (screen.width-800)/2,
            	top:(screen.height-750)/2
            });
        	
        	$('#pwdWin').window({
                title: '重置密码',
                width: 520,
                modal: true,
                shadow: true,
                closed: true,
                height: 450,
            	left: (screen.width-800)/2,
            	top:(screen.height-750)/2
            });
        	
        	$('#roleWin').window({
        		title:'角色',
                width: 520,
                modal: true,
                shadow: true,
                closed: true,
                height: 450,
            	left: (screen.width-800)/2,
            	top:(screen.height-750)/2
            });
        	
        	$('#add-save').on('click', function(){
        		
        		$('#addForm').form({
        			url:'<%=request.getContextPath()%>/sys/saveUser',
        			onSubmit:function(){
        				$('#deptId').val($('#addDept').combotree('getValue'));
        				return $(this).form('validate');
        			},
        			success:function(data){
        				var data = eval('(' + data + ')');
        				if(data.flag){
    						msgShow('提示','保存成功','info');
    						$('#addWin').window('close');
    						$('#userList').datagrid('reload');
    						$('#tt').tree('reload');
    					}else{
    						msgShow('提示','保存失败','error');
    					}
        			},
        			error:function(){
        				msgShow('提示','保存失败','error');
        			}
        		});
        		
        		$('#addForm').submit();
        	});
        	
        	$('#add-cancel').on('click', function(){
        		$('#addWin').window('close');
        	});
        	
        	$('#edit-save').on('click', function(){
        		$('#editForm').form({
        			url:'<%=request.getContextPath()%>/sys/updateUser',
        			onSubmit:function(){
        				$('#editDept').val($('#editDept').combotree('getValue'));
        				return $(this).form('validate');
        			},
        			success:function(data){
        				var data = eval('(' + data + ')');
        				if(data.flag){
    						msgShow('提示','更新成功','info');
    						$('#editWin').window('close');
    						$('#userList').datagrid('reload');
    						$('#tt').tree('reload');
    					}else{
    						msgShow('提示','更新失败','error');
    					}
        			},
        			error:function(){
        				msgShow('提示','更新失败','error');
        			}
        		});
        		
        		$('#editForm').submit();
        	});
        	
        	$('#edit-cancel').on('click', function(){
        		$('editWin').window('close');
        	});
        	
        	$('#pwd-save').on('click', function(){
        		$('#pwdForm').form({
        			url:'<%=request.getContextPath()%>/sys/reloadPwd',
        			onSubmit:function(){
        				return $(this).form('validate');
        			},
        			success:function(data){
        				var data = eval('(' + data + ')');
        				if(data.flag){
    						msgShow('提示','更新成功','info');
    						$('#pwdWin').window('close');
    						$('#userList').datagrid('reload');
    						$('#tt').tree('reload');
    					}else{
    						msgShow('提示','更新失败','error');
    					}
        			},
        			error:function(){
        				msgShow('提示','更新失败','error');
        			}
        		});
        		
        		$('#pwdForm').submit();
        	});
        	
        	$('#pwd-cancel').on('click', function(){
        		$('#pwdWin').window('close');
        	});
        	
        	$('#role-save').on('click', function(){
        		var roleIds = '';
        		var datas = $('#roleList').datagrid('getChecked');
        		$.each(datas, function(index, data){
        			roleIds += data.id + ",";
        		});
        		
        		if(strIsNull(roleIds)){
        			msgShow('提示','请选择角色','info');
        			return;
        		}
        		
        		$.ajax({
        			url:"<%=request.getContextPath()%>/sys/saveUserRoles",
    				type:"post",
    				data:'roleIds=' + roleIds + '&userId=' + $('#role_userId').val(),
    				dataType:"json",
    				success:function(data, textStatus){
    					if(data.flag){
    						msgShow('提示','保存成功','info');
    						$('#roleWin').window('close');
    						$('#adminList').datagrid('reload');
    					}else{
    						msgShow('提示','保存失败','error');
    					}
    				},
    				error:function(){
    					msgShow('提示', '保存失败' , 'error');
    				},
    				async:false
        		});
        	});
        	
        	$('#role-cancel').on('click', function(){
        		$('#roleWin').window('close');
        	});
        });
		
		
    </script>
    </head>
    <body class="easyui-layout" style="overflow-y: hidden"  scroll="no">
		<div region="west" style="width:240px;" id="west">
			<div style="height: 20px;"></div>
      		<ul id="tt" class="easyui-tree"></ul>
    	</div>
		<div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
      		
      		<table id="userList"></table>
    		
    		<div id="addWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
        		<input type="hidden" id="pid" value="1">
        		<form action="#" id="addForm" method="post">
        			<table style="width: 500px;">
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						用户名：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc; padding-left: 10px;">
        						<input name="username" id="addUsername" style="width: 250px;"
        							class="easyui-validatebox" data-options="required:true"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						密码：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input type="password" name="password" id="addPassword" style="width: 250px;"
        							class="easyui-validatebox" data-options="required:true"/>
        					</td>
        				</tr>
        				
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						密码确认：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input type="password" id="addPasswordConfirm" style="width: 250px;"
        							class="easyui-validatebox" required="required" validType="equals['#addPassword']"/>
        					</td>
        				</tr>
        				
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						真实姓名：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="realname" id="addRealname" style="width: 250px;"
        							class="easyui-validatebox" data-options="required:true"/>
        					</td>
        				</tr>
        				
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						邮箱：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="email" id="addEmail" style="width: 250px;"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-bottom:1px solid #ccc;width: 40%;text-align: right;">
        						部门：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;border-bottom:1px solid #ccc;padding-left: 10px;">
        						<input id="addDept" style="width: 250px;">
        						<input name="deptId" id="deptId" type="hidden" value="1">
        					</td>
        				</tr>
        			</table>
        		</form>
        		<div style="height: 20px;"></div>
        		<table style="width: 100%;">
    	  			<tr>
    	  				<td style="text-align: center;">
    	  					<a id="add-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
                			<a id="add-cancel" class="easyui-linkbutton" iconCls="icon-cancel">取消</a>
    	  				</td>
    	  			</tr>
    			</table>
        	</div>
        	
        	<div id="editWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-edit">
        		<form action="#" id="editForm" method="post">
        			<input type="hidden" name="id" id="id" value="0">
        			<table style="width: 500px;">
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						状态：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input  name="isdisable" id="editStatus" style="width: 250px;"/>
        					</td>
        				</tr>
        				
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						真实姓名：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="realname" id="editRealname" style="width: 250px;"
        							class="easyui-validatebox" data-options="required:true"/>
        					</td>
        				</tr>
        				
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						邮箱：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="email" id="editEmail" style="width: 250px;"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-bottom:1px solid #ccc;width: 40%;text-align: right;">
        						部门：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;border-bottom:1px solid #ccc;padding-left: 10px;">
        						<input id="editDept" style="width: 250px;">
        						<input name="deptId" id="editDeptId" type="hidden" value="1">
        					</td>
        				</tr>
        			</table>
        		</form>
        		<div style="height: 20px;"></div>
        		<table style="width: 100%;">
    	  			<tr>
    	  				<td style="text-align: center;">
    	  					<a id="edit-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
                			<a id="edit-cancel" class="easyui-linkbutton" iconCls="icon-cancel">取消</a>
    	  				</td>
    	  			</tr>
    			</table>
        	</div>
        	
        	<div id="pwdWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
        		<form action="#" id="pwdForm">
        			<input type="hidden" id="pwdId" name="id"/>
        			<input type="hidden" id="salt" name="salt">
        			<table style="width: 500px; padding-top: 10px; padding-left: 5px;" cellpadding="0" cellspacing="0">
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						新密码：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input id="pwdPassword" name="password" type="password" style="width: 250px;"
        							class="easyui-validatebox" data-options="required:true"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; border-bottom: 1px solid #ccc;width: 40%;text-align: right;">
        						新密码确认：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-bottom: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input type="password" style="width: 250px;" class="easyui-validatebox" required="required" validType="equals['#pwdPassword']"/>
        					</td>
        				</tr>
        			</table>
        		</form>
        		<div style="height: 20px;"></div>
        		<table style="width: 100%;">
    	  			<tr>
    	  				<td style="text-align: center;">
    	  					<a id="pwd-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
                			<a id="pwd-cancel" class="easyui-linkbutton" iconCls="icon-cancel">取消</a>
    	  				</td>
    	  			</tr>
    			</table>
        	</div>
        	
        	<div id="roleWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-ok">
        		<input type="hidden" id="role_userId">
        		<table id="roleList"></table>
        		<div style="height: 20px;"></div>
        		<table style="width: 100%;">
    	  			<tr>
    	  				<td style="text-align: center;">
    	  					<a id="role-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
                			<a id="role-cancel" class="easyui-linkbutton" iconCls="icon-cancel">取消</a>
    	  				</td>
    	  			</tr>
    			</table>
        	</div>
    	</div>
	</body>
</html>
