<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>出库</title>
<link id="easyuiTheme" href="<%=request.getContextPath()%>/themes/metro/easyui.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath()%>/themes/icon.css" rel="stylesheet" type="text/css" />
<script src="<%=request.getContextPath()%>/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/jquery.easyui.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/easyui-lang-zh_CN.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/js/outlook2.js" type="text/javascript"></script>

<script type="text/javascript">
$(function(){
	$('.datebox').datebox({
		editable:false
	});
	
	$('#entrepotLogList').datagrid({
		url: '<%=request.getContextPath()%>/entrepot/getOutEntrepotList',
		toolbar:[
			{iconCls : 'icon-add', text : '出库', 
			 handler: 
				function(){
					addOutEntrepot();
			 	}
			}
		],
		fitColumns: true,
		striped: true,
		singleSelect:true,
		rownumbers:true,
		pagination:true,
		columns:[[
			{field:'code',title:'编号',width:80},		
			{field:'goodsName',title:'名称',width:80},
			{field:'goodsModel',title:'规格',width:80},
			{field:'goodsBrand',title:'品牌',width:80},
			{field:'goodsUnitName',title:'单位',width:80},
			{field:'createTimeStr',title:'出库时间',width:80},
			{field:'receiveUserName',title:'接收人',width:80},
			{field:'amount',title:'数量',width:80},
			{field:'remark',title:'备注',width:80}
		]]
	});
	//分页
	var p = $('#entrepotLogList').datagrid('getPager'); 
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
			{field:'goodsName',title:'名称',width:80},
			{field:'goodsModel',title:'规格',width:80},
			{field:'goodsBrand',title:'品牌',width:80},
			{field:'goodsUnitName',title:'单位',width:80},
			{field:'entrepotName',title:'仓库',width:80},
			{field:'shelfName',title:'货架',width:80},
			{field:'quantity',title:'库存量',width:80},
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
	
	//加载所有仓库管理员
	//$('#add-receiver').combobox({
		//url:'<%=request.getContextPath()%>/user/getAllUsers',
		//valueField:'id',
		//textField:'text',
		//required:true
	//});
	
	//加载所有接收人
	//$('#search-receiveUser').combobox({
		//valueField:'id',
		//textField:'text',
		//editable:false
	//});
	
	//$.ajax({
		//url:'<%=request.getContextPath()%>/user/getAllUsers',
		//type:'post',
		//dataType:'json',
		//success:function(data){
			//data.unshift({"id":"", "text":"全部"});
			//$('#search-receiveUser').combobox('loadData', data);
		//},
		//async:true
	//});
	
	//搜索出库记录
	$('#search').on('click', function(){
		var queryParams = {};
		var params = $('.searchParam');
		for(i=0;i<params.length;i++){
			if($(params[i]).val() != ''){
				queryParams[$(params[i]).attr('name')] = $(params[i]).val();
			}
		}
		
		queryParams.createDateStrBegin = $('#createDateStrBegin').datebox('getValue');
		queryParams.createDateStrEnd = $('#createDateStrEnd').datebox('getValue');
		//queryParams.receiveUser = $('#search-receiveUser').combobox('getValue');
		
		$('#entrepotLogList').datagrid('options').queryParams = queryParams;
		$('#entrepotLogList').datagrid('reload');
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
	
	$('#addOutEntrepotWin').window({
		title: '出库',
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
		width: 1150,
		modal: true,
        shadow: true,
        closed: true,
        height: 560,
        top:0,
        left:0
	});
	
	//选择物品
	$('#choose-goods').on('click', function(){
		$('#tt').tree({
    	    url:'<%=request.getContextPath()%>/sys/getGoodsTypeTree',
    	    onClick: function(node){
    	    	$('#tid').val(node.id);
    			$('#goodsList').datagrid({url:'<%=request.getContextPath()%>/entrepot/getGoodsStockByTid?tid=' + node.id});
    		}
    	});
		$('#goodsWin').window('open');
	});
	
	//新增
	$('#addForm').form({
		url:'<%=request.getContextPath()%>/entrepot/outEntrepot',
		onSubmit:function(){
			if($(this).form('validate')){
				MaskUtil.mask();
			}
			
			//$('#addReceiver').val($('#add-receiver').combobox('getValue'));
			
			return $(this).form('validate');
		},
		success:function(data){
			MaskUtil.unmask();
			var data = eval('(' + data + ')');
			if(data.flag){
				msgShow('提示','保存成功','info');
				$('#addOutEntrepotWin').window('close');
				$('#entrepotLogList').datagrid('reload');
				$('#addForm').form('reset');
			}else{
				msgShow('提示','保存失败,请查看库存是否充足','error');
			}
		}
	});
	
	$('#add-save').on('click', function(){
		$('#addForm').submit();
	});
	
});

//新增产品
function addOutEntrepot(){
	$('#addOutEntrepotWin').window('open');
}

//选择物品
function selectGoods(data){
	//设置入库物品信息
	$('#goodsId').val(data.goodsId);
	$('#entrepotId').val(data.entrepotId);
	$('#shelfId').val(data.shelfId);
	
	$('#goodsName').html(data.goodsName);
	$('#goodsModel').html(data.goodsModel);
	$('#goodsUnit').html(data.goodsUnitName);
	$('#goodsBrand').html(data.goodsBrand);
	$('#entrepotName').html(data.entrepotName);
	$('#shelfName').html(data.shelfName);
	$('#showQuantity').html(data.quantity);
	
	//清空物品库搜索条件
	$('#search-name').val('');
	$('#search-code').val('');
	$('#search-model').val('');
	$('#search-brand').val('');
	
	//关闭物品库窗口
	$('#goodsWin').window('close');
}
</script>
</head>
<body>
	<table
		style="width: 100%; height: auto; border: 1px solid #ccc; font-size: 12px; color: #888; padding: 5px;">
		<tr style="line-height: 30px;">
			<td style="text-align: right;">编号：</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="searchParam" name="code"/>
			</td>
			<td style="text-align: right;">名称：</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="searchParam" name="name"/>
			</td>
			<td style="text-align: right;">规格：</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="searchParam" name="model"/>
			</td>

			<td style="text-align: right;">品牌：</td>
			<td style="text-align: left;">
				<input style="width: 75%; height: 17px;" class="searchParam" name="brand"/>
			</td>
		</tr>
		<tr>
			<td style="text-align: right;">出库时间：</td>
			<td style="text-align: left;">
				<input style="width: 180px;" class="datebox" id="createDateStrBegin"/>
			</td>
			<td style="text-align: left;">-</td>
			<td style="text-align: left;">
				<input style="width: 180px;" class="datebox" id="createDateStrEnd"/>
			</td>
			<td style="text-align: right;">接收人：</td>
			<td style="text-align: left;">
				<input style="width: 180px;" class="searchParam" name="receiveUserName"/>
			</td>

			<td style="text-align: right;"></td>
			<td style="text-align: left;">
				<a id="search" class="easyui-linkbutton" style="height: 25px;"
					iconCls="icon-search">搜索</a>
			</td>
		</tr>

	</table>
	<div style="height: 10px;"></div>
	<table id="entrepotLogList">
	</table>
	
	<div id="addOutEntrepotWin" class="easyui-window" collapsible="false"
		minimizable="false" maximizable="false" iconCls="icon-add">
		<div align="center" style="margin: 20px;">
			<form action="#" method="post" id="addForm">
				<input type="hidden" id="goodsId" name="goodsId"/>
				<input type="hidden" id="entrepotId" name="entrepotId"/>
				<input type="hidden" id="shelfId" name="shelfId"/>
				<input type="hidden" name="type" value="1"/>
				<table width="300" border="0" align="center">
					<tr>
						<td colspan="2">
							<a class="easyui-linkbutton" iconCls="icon-add" id="choose-goods">选择物品</a>
						</td>
					</tr>
					
					<tr style="line-height: 30px;">
						<td width="60">产品名称：</td>
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
					
					<tr style="line-height: 30px;">
						<td>仓库：</td>
						<td id="entrepotName"></td>
					</tr>
					
					<tr style="line-height: 30px;">
						<td>货架：</td>
						<td id="shelfName"></td>
					</tr>
					
					<tr style="line-height: 30px;">
						<td>库存量：</td>
						<td id="showQuantity"></td>
					</tr>
					
					<tr>
						<td>收货人：</td>
						<td>
							<!--
							<input id="add-receiver" style="width: 200px;"/>
							<input type="hidden" id="addReceiver" name="receiveUserId"/>
							-->
							<input id="addReceiver" name="receiveUserName" style="width:200px;"/>
						</td>
					</tr>
					
					<tr>
						<td>数量：</td>
						<td>
							<input name="amount" class="easyui-validatebox" required="true"
								validType="nums" style="width: 200px;">
						</td>
					</tr>
					
					<tr>
						<td>备注：</td>
						<td>
							<textarea name="remark" style="width: 200px; height: 60px; margin: 5px;"></textarea>
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
    	
    	<div style="position: absolute;left: 180px; top: 0; width: 935px;height: 520px;">
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
</body>
</html>