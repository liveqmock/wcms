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
        	$('#roleList').datagrid({
        		url:'<%=request.getContextPath()%>/sys/getRoleList',
    			title: '角色列表',
    			toolbar:[
    			    {iconCls : 'icon-add', 
    			     text : '新增', 
					 handler: 
					 	function(){
							$('#addWin').window('open');
						}
					},
					{iconCls : 'icon-edit', 
	    			 text : '编辑', 
					 handler: 
					 	function(){
						 	var data = $('#roleList').datagrid('getSelected');
						 	if(data==null){
						 		msgShow('提示', '请选中需要编辑的数据' , 'warning');
						 		return;
						 	}
						 	$('#id').val(data.id);
						 	$('#editName').val(data.name);
						 	$('#editCode').val(data.code);
						 	$('#editDesc').val(data.sdesc);
							$('#editWin').window('open');
						}
					},
					{iconCls : 'icon-ok', 
		    			 text : '权限', 
						 handler: 
						 	function(){
							 var data = $('#roleList').datagrid('getSelected');
								if(data==null){
							 		msgShow('提示', '请选中需要编辑权限的角色' , 'warning');
							 		return;
							 	}
								$('#roleId').val(data.id);
								
								$('#actionList').tree({
									cascadeCheck:false,
									checkbox:true,
								    url:'<%=request.getContextPath()%>/sys/getRoleAction?roleId=' + data.id,
								    idField:'id',
								    treeField:'name',
								    columns:[[
								        {title:'Task Name',field:'name',width:180},
								        {field:'persons',title:'Persons',width:60,align:'right'},
								        {field:'begin',title:'Begin Date',width:80},
								        {field:'end',title:'End Date',width:80}
								    ]]
								});
								$('#actionWin').window('open');
							}
						},
					{iconCls : 'icon-remove', 
		    		 text : '删除', 
					 handler: 
					 	function(){
							var data = $('#roleList').datagrid('getSelected');
							if(data==null){
						 		msgShow('提示', '请选中需要删除的数据' , 'warning');
						 		return;
						 	}
							$.messager.confirm('系统提示', '您确定要删除本条数据吗?', function(r) {
								if(r){
									$.ajax({
					        			url:"<%=request.getContextPath()%>/sys/deleteRole",
					    				type:"post",
					    				data:'id=' + data.id,
					    				dataType:"json",
					    				success:function(data, textStatus){
					    					if(data.flag){
					    						msgShow('提示','删除成功','info');
					    						$('#addWin').window('close');
					    						$('#roleList').datagrid('reload');
					    						$('#tt').tree('reload');
					    					}else{
					    						msgShow('提示','删除失败','error');
					    					}
					    				},
					    				error:function(){
					    					msgShow('提示', '删除失败' , 'error');
					    				},
					    				async:false
					        		});
			                    }
			                });
						}
					}
    			],
    			fitColumns: true,
    			striped: true,
    			singleSelect:true,
    			rownumbers:true,
    			pagination:true,
    			columns:[[
    			    {field:'id', title:'ID',width:80},
    				{field:'name',title:'角色名称',width:80},
    				{field:'code',title:'角色编码',width:80},
    				{field:'sdesc',title:'角色描述',width:80}
    			]],
    			onDblClickRow:function(rowIndex, rowData) {  
    				viewOrder(); 
    	        },
    		});
        	
        	var rolePage = $('#roleList').datagrid('getPager'); 
    		rolePage.pagination({  
    	        pageSize : 10,// 每页显示的记录条数，默认为20  
    	        pageList : [10,20,30],// 可以设置每页记录条数的列表  
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
        	
        	$('#actionWin').window({
                title: '权限',
                width: 220,
                modal: true,
                shadow: true,
                closed: true,
                height: 450,
            	left: (screen.width-800)/2,
            	top:(screen.height-750)/2
            });
        	
        	$('#add-save').on('click', function(){
        		if(strIsNull($('#addName').val())){
        			msgShow('缺少信息','角色名称不能为空','warning');
        			return;
        		}
        		
        		if(strIsNull($('#addCode').val())){
        			msgShow('缺少信息','角色编码不能为空','warning');
        			return;
        		}
        		
        		$.ajax({
        			url:"<%=request.getContextPath()%>/sys/saveRole",
    				type:"post",
    				data:$('#addForm').serialize(),
    				dataType:"json",
    				success:function(data, textStatus){
    					if(data.flag){
    						msgShow('提示','保存成功','info');
    						$('#addName').val('');
    						$('#addCode').val('');
    						$('#addDesc').val('');
    						$('#addWin').window('close');
    						$('#roleList').datagrid('reload');
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
        	
        	$('#add-cancel').on('click', function(){
        		$('#addWin').window('close');
        	});
        	
        	$('#edit-save').on('click', function(){
        		if(strIsNull($('#editName').val())){
        			msgShow('缺少信息','角色名称不能为空','warning');
        			return;
        		}
        		
        		if(strIsNull($('#editCode').val())){
        			msgShow('缺少信息','角色编码不能为空','warning');
        			return;
        		}
        		
        		$.ajax({
        			url:"<%=request.getContextPath()%>/sys/updateRole",
    				type:"post",
    				data:$('#editForm').serialize(),
    				dataType:"json",
    				success:function(data, textStatus){
    					if(data.flag){
    						msgShow('提示','更新成功','info');
    						$('#editWin').window('close');
    						$('#roleList').datagrid('reload');
    					}else{
    						msgShow('提示','更新失败','error');
    					}
    				},
    				error:function(){
    					msgShow('提示', '更新失败' , 'error');
    				},
    				async:false
        		});
        	});
        	
        	$('#edit-cancel').on('click', function(){
        		$('editWin').window('close');
        	});
        	
        	$('#action-save').on('click', function(){
        		var menuIds = '';
        		var nodes = $('#actionList').tree('getChecked');
        		$.each(nodes, function(index, node){
        			menuIds += node.id + ",";
        		});
        		
        		if(strIsNull(menuIds)){
        			msgShow('提示','请选择菜单','info');
        			return;
        		}
        		$.ajax({
        			url:"<%=request.getContextPath()%>/sys/saveRoleMenus",
    				type:"post",
    				data:'menuIds=' + menuIds + '&roleId=' + $('#roleId').val(),
    				dataType:"json",
    				success:function(data, textStatus){
    					if(data.flag){
    						msgShow('提示','更新成功','info');
    						$('#actionWin').window('close');
    					}else{
    						msgShow('提示','更新失败','error');
    					}
    				},
    				error:function(){
    					msgShow('提示', '更新失败' , 'error');
    				},
    				async:false
        		});
        	});
        	
        	$('#action-cancel').on('click', function(){
        		$('#actionWin').window('close');
        	});
        });
		
		
    </script>
    </head>
    <body class="easyui-layout" style="overflow-y: hidden"  scroll="no">
		<div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
      		
      		<table id="roleList"></table>
    		
    		<div id="addWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-add">
        		<form action="#" id="addForm">
        			<input type="hidden" name="pid" id="pid" value="0">
        			<table style="width: 500px;">
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						角色名称：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc; padding-left: 10px;">
        						<input name="name" id="addName" style="width: 250px;"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						角色编码：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="code" id="addCode" style="width: 250px;"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						角色描述：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="sdesc" id="addDesc" style="width: 250px;"/>
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
        		<form action="#" id="editForm">
        			<input type="hidden" name="id" id="id" value="0">
        			<table style="width: 500px;">
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						角色名称：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc; padding-left: 10px;">
        						<input name="name" id="editName" style="width: 250px;"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						角色编码：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="code" id="editCode" style="width: 250px;"/>
        					</td>
        				</tr>
        			
        				<tr style="line-height: 30px;">
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc; width: 40%;text-align: right;">
        						角色描述：
        					</td>
        					<td style="border-top: 1px solid #ccc; border-left: 1px solid #ccc;border-right:1px solid #ccc;padding-left: 10px;">
        						<input name="sdesc" id="editDesc" style="width: 250px;"/>
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
        	
        	<div id="actionWin" class="easyui-window" collapsible="false" minimizable="false"
        		maximizable="false" iconCls="icon-ok">
        		<input type="hidden" id="roleId">
        		<ul id="actionList"></ul>
        		<div style="height: 20px;"></div>
        		<table style="width: 100%;">
    	  			<tr>
    	  				<td style="text-align: center;">
    	  					<a id="action-save" class="easyui-linkbutton" iconCls="icon-save">保存</a>
                			<a id="action-cancel" class="easyui-linkbutton" iconCls="icon-cancel">取消</a>
    	  				</td>
    	  			</tr>
    			</table>
        	</div>
    	</div>
	</body>
</html>
