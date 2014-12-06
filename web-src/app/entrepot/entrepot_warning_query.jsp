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
		$('#warningList').datagrid({
			url: '<%=request.getContextPath()%>/entrepot/getWarningList',
			title:'库存预警列表',
			fitColumns: true,
			striped: true,
			singleSelect:true,
			rownumbers:true,
			pagination:true,
			columns:[[		
				{field:'goodsName',title:'物品名称',width:80},
				{field:'goodsModel',title:'物品规格',width:80},
				{field:'goodsBrand',title:'物品品牌',width:80},
				{field:'goodsUnitName',title:'单位',width:80},
				{field:'stockQuantity',title:'库存量',width:80, align:'right',
					formatter:function(value, rowData, rowIndex){
						return '<font color="red">' + value + '</font>'
					}
				},
				{field:'warningQuantity',title:'预警量',width:80, align:'right'}
			]]
		});
		//分页
		var p = $('#warningList').datagrid('getPager'); 
		p.pagination({  
	        pageSize : 10,// 每页显示的记录条数，默认为20  
	        pageList : [ 10, 20, 30 ],// 可以设置每页记录条数的列表  
	        beforePageText : '第',// 页数文本框前显示的汉字  
	        afterPageText : '页    共 {pages} 页',  
	        displayMsg : '当前显示 {from} - {to} 条记录   共 {total} 条记录'   
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
			
			$('#warningList').datagrid('options').queryParams = queryParams;
			$('#warningList').datagrid('reload');
		});
	});
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
	<table id="warningList"></table>
</body>
</html>