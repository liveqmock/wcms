<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>库存预警设置</title>
<link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/outlook2.js" type="text/javascript"></script>

<script type="text/javascript">
	$(function(){
		$('#warningSettingList').datagrid({
			url: '<%=request.getContextPath()%>/entrepot/getWarningSettingList',
			toolbar:[
				{iconCls : 'icon-add', text : '新增', 
				 handler: 
					function(){
						$('#addWin').window('open');
				 	}
				},
				{iconCls : 'icon-remove', text : '删除', 
				 handler: 
					function(){
					 	var data = $('#warningSettingList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要删除的数据' , 'warning');
					 		return;
					 	}
						deleteWarningSetting(data);
				 	}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[		
				{field:'goodsName',title:'物品名称',width:80},
				{field:'goodsModel',title:'物品规格',width:80},
				{field:'goodsBrand',title:'物品品牌',width:80},
				{field:'quantity',title:'预警数量',width:80}
			]]
		});
		//分页
		var p = $('#warningSettingList').datagrid('getPager'); 
		p.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		
		$('#goodsList').datagrid({
			title:'物品库',
			toolbar:[
				{iconCls : 'icon-add', text : '新增物品', 
				 handler: 
					function(){
					 	if(strIsNull($('#tid').val())){
					 		msgShow('提示','请先选定类别,再添加物品','info');
					 		return;
					 	}
						$('#addGoodsWin').window('open');
				 	}
				},
				{iconCls : 'icon-ok', text : '确认选择', 
				 handler: 
					function(){
					 	var data = $('#goodsList').datagrid('getSelected');
						if(data==null){
					 		msgShow('提示', '请选中需要选择的数据' , 'warning');
					 		return;
					 	}
						selectGoods(data);
				 	}
				}
			],
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[
				{field:'name',title:'名称',width:80},
				{field:'model',title:'规格',width:80},
				{field:'brand',title:'品牌',width:80},
				{field:'unitName',title:'单位',width:80},
				{field:'remark',title:'备注',width:80}
			]]
		});
		
		var p1 = $('#goodsList').datagrid('getPager'); 
		p1.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
	    });
		
		//加载单位
		$('#goods-unit').combobox({
			url:'<%=request.getContextPath()%>/sys/getAllUnit',
			valueField:'id',
			textField:'name',
			editable:false,
			required:true
		});
		
		//搜索
		$('#search').on('click', function(){
			var queryParams = {};
			var params = $('.searchParam');
			for(i=0;i<params.length;i++){
				if($(params[i]).val() != ''){
					queryParams[$(params[i]).attr('name')] = $(params[i]).val();
				}
			}
			
			$('#warningSettingList').datagrid('options').queryParams = queryParams;
			$('#warningSettingList').datagrid('reload');
		});
		
		//搜索物品库
		$('#goods-search').on('click', function(){
			var queryParams = {};
			var params = $('.queryParam');
			for(i=0;i<params.length;i++){
				if($(params[i]).val() != ''){
					queryParams[$(params[i]).attr('name')] = $(params[i]).val();
				}
			}
			
			$('#goodsList').datagrid('options').queryParams = queryParams;
			$('#goodsList').datagrid('reload');
		});
		
		//新增物品
		$('#addGoodsForm').form({
			url:'<%=request.getContextPath()%>/sys/addGoods',
			onSubmit:function(){
				if($(this).form('validate')){
					MaskUtil.mask();
				}
				$('#addGoodsUnit').val($('#goods-unit').combobox('getValue'));
				return $(this).form('validate');
			},
			success:function(data){
				MaskUtil.unmask();
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#addGoodsWin').window('close');
					$('#goodsList').datagrid('reload');
					$(this).form('reset');
				}else{
					msgShow('提示',data.msg,'error');
				}
			}
		});
		
		$('#add-goods-save').on('click', function(){
			$('#addGoodsForm').submit();
		});
		
		//新增
		$('#addForm').form({
			url:'<%=request.getContextPath()%>/entrepot/addWarningSetting',
			onSubmit:function(){
				if(strIsNull($('#goodsId').val())){
					msgShow('提示','请选择物品','warning');
					return false;
				}
				
				if($(this).form('validate')){
					MaskUtil.mask();
				}
				
				return $(this).form('validate');
			},
			success:function(data){
				MaskUtil.unmask();
				var data = eval('(' + data + ')');
				if(data.flag){
					msgShow('提示','保存成功','info');
					$('#addWin').window('close');
					$('#warningSettingList').datagrid('reload');
					$('#addForm').form('reset');
					
					$('#goodsId').val('');
					$('#goodsName').html('');
					$('#goodsModel').html('');
					$('#goodsUnit').html('');
					$('#goodsBrand').html('');
				}else{
					msgShow('提示','保存失败','error');
				}
			}
		});
		
		$('#add-save').on('click', function(){
			$('#addForm').submit();
		});
		
		//选择物品
		$('#choose-goods').on('click', function(){
			$('#tt').tree({
        	    url:'<%=request.getContextPath()%>/sys/getGoodsTypeTree',
        	    onClick: function(node){
        	    	$('#tid').val(node.id);
        			$('#goodsList').datagrid({url:'<%=request.getContextPath()%>/sys/getGoodsByTid?tid=' + node.id});
        		}
        	});
			$('#goodsWin').window('open');
		});
		
		$('#addWin').window({
			title: '设置库存预警数量',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 550,
            top:0,
            left:200
		});
		
		$('#goodsWin').window({
			title: '选择物品',
			width: 900,
			modal: true,
            shadow: true,
            closed: true,
            height: 560,
            top:0,
            left:0
		});
		
		$('#addGoodsWin').window({
			title: '新增物品',
			width: 500,
			modal: true,
            shadow: true,
            closed: true,
            height: 560,
            top:0,
            left:100
		});
	});
	
	//选择物品
	function selectGoods(data){
		//设置入库物品信息
		$('#goodsId').val(data.id);
		$('#goodsName').html(data.name);
		$('#goodsModel').html(data.model);
		$('#goodsUnit').html(data.unitName);
		$('#goodsBrand').html(data.brand);
		
		//清空物品库搜索条件
		$('#search-name').val('');
		$('#search-code').val('');
		$('#search-model').val('');
		$('#search-brand').val('');
		
		//关闭物品库窗口
		$('#goodsWin').window('close');
	}
	
	function deleteWarningSetting(data){
		$.ajax({
			url:'<%=request.getContextPath()%>/entrepot/deleteWarningSetting?id=' + data.id,
			type:'post',
			dataType:'json',
			success:function(data){
				if(data.flag){
					msgShow('提示','删除成功','info');
					$('#warningSettingList').datagrid('reload');
				}else{
					msgShow('提示','删除失败','error');
				}
			},
			async:true
		});
	}
</script>
</head>
<body>
	<table
		style="width: 100%; height: auto; border: 1px solid #ccc; font-size: 12px; color: #888; padding: 5px;">
		<tr style="line-height: 30px;">
			<td style="text-align: right;">物品名称：</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="searchParam" name="goodsName"/>
			</td>
			<td style="text-align: right;">物品规格：</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="searchParam" name="goodsModel"/>
			</td>

			<td style="text-align: right;">物品品牌：</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="searchParam" name="goodsBrand"/>
			</td>
			
			<td style="text-align: right;"></td>
			<td style="text-align: left;">
				<a id="search" class="easyui-linkbutton" style="height: 25px;"
					iconCls="icon-search">搜索</a>
			</td>
		</tr>
	</table>
	<div style="height: 10px;"></div>
	<table id="warningSettingList"></table>
	
	<div id="addWin" class="easyui-window" collapsible="false"
		minimizable="false" maximizable="false" iconCls="icon-add">
		<div align="center" style="margin: 20px;">
			<form action="#" method="post" id="addForm">
				<input type="hidden" id="goodsId" name="goodsId"/>
				<table width="300" border="0" align="center">
					<tr>
						<td colspan="2">
							<a class="easyui-linkbutton" iconCls="icon-add" id="choose-goods">选择物品</a>
						</td>
					</tr>
					
					<tr style="line-height: 30px;">
						<td width="60">物品名称：</td>
						<td id="goodsName"></td>
					</tr>
					<tr style="line-height: 30px;">
						<td>规格型号：</td>
						<td id="goodsModel"></td>
					</tr>
					
					<tr style="line-height: 30px;">
						<td>单位：</td>
						<td id="goodsUnit"></td>
					</tr>
					
					<tr style="line-height: 30px;">
						<td>品牌：</td>
						<td id="goodsBrand"></td>
					</tr>
					
					<tr>
						<td>数量：</td>
						<td>
							<input name="quantity" class="easyui-validatebox" required="true"
								validType="nums" style="width: 200px;">
						</td>
					</tr>

					<tr>
						<td style="text-align: center;" colspan="2">
							<a class="easyui-linkbutton" iconCls="icon-save" id="add-save">保存</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	
	<div id="goodsWin" class="easyui-window" collapsible="false"
		minimizable="false" maximizable="false" iconCls="icon-search" style="position: relative;">
		
		<div style="width:180px;height:520px; position: absolute; left: 0; top: 0;border-right: 1px solid #ccc;">
			<div style="height: 20px;"></div>
      		<ul id="tt" class="easyui-tree"></ul>
    	</div>
    	
    	<div style="position: absolute;left: 180px; top: 0; width: 685px;height: 520px;">
			<table style="width: 100%; height: auto; border-bottom: 1px solid #ccc;border-right: 1px solid #ccc; font-size: 12px; color: #888; padding: 5px;">
				<tr style="line-height: 30px;">
					<td style="text-align: right;">名称：</td>
					<td style="text-align: left;">
						<input style="width: 75%; height: 17px;" class="queryParam" id="search-name" name="name"/>
					</td>
					<td style="text-align: right;">编码：</td>
					<td style="text-align: left;">
						<input style="width: 75%; height: 17px;" class="queryParam" id="search-code" name="code"/>
					</td>
					<td style="text-align: right;"></td>
					<td style="text-align: left;"></td>
				</tr>
				<tr>
					<td style="text-align: right;">规格：</td>
					<td style="text-align: left;">
						<input style="width: 75%; height: 17px;" class="queryParam" id="search-model" name="model"/>
					</td>
					<td style="text-align: right;">品牌：</td>
					<td style="text-align: left;">
						<input style="width: 75%; height: 17px;" class="queryParam" id="search-brand" name="brand"/>
					</td>
					<td style="text-align: center;" colspan="2">
						<a id="goods-search" class="easyui-linkbutton" style="height: 25px;" iconCls="icon-search">搜索</a>
					</td>
				</tr>
			</table>
			<table id="goodsList"></table>
		</div>
	</div>
	
	<div id="addGoodsWin" class="easyui-window" collapsible="false"
		minimizable="false" maximizable="false" iconCls="icon-add">
		<div align="center" style="margin: 20px;">
			<form action="#" method="post" id="addGoodsForm">
				<input type="hidden" id="tid" name="typeId">
				<input type="hidden" id="addGoodsUnit" name="unit">
				<table width="300" border="0" align="center">
					
					<tr style="line-height: 30px;">
						<td width="60">物品名称：</td>
						<td>
							<input name="name" class="easyui-validatebox" required="true"/>
						</td>
					</tr>
					<tr style="line-height: 30px;">
						<td>规格型号：</td>
						<td>
							<input name="model" class="easyui-validatebox" required="true"/>
						</td>
					</tr>
					<tr style="line-height: 30px;">
						<td>品牌：</td>
						<td>
							<input name="brand" class="easyui-validatebox" />
						</td>
					</tr>
					
					<tr>
						<td>单位：</td>
						<td>
							<input id="goods-unit"/>
							<a class="easyui-linkbutton" iconCls="icon-reload" id="add-goods-reload">刷新</a>
						</td>
					</tr>
					
					<tr>
						<td>备注：</td>
						<td>
							<textarea name="remark" style="width: 200px; height: 30px; margin: 5px;"></textarea>
						</td>
					</tr>

					<tr>
						<td style="text-align: center;" colspan="2">
							<a class="easyui-linkbutton" iconCls="icon-save" id="add-goods-save">保存</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</body>
</html>