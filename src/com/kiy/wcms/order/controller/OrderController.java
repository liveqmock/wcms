package com.kiy.wcms.order.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.kiy.wcms.Global;
import com.kiy.wcms.order.entity.Order;
import com.kiy.wcms.order.entity.OrderDetail;
import com.kiy.wcms.order.entity.OrderParam;
import com.kiy.wcms.order.service.OrderService;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.UserService;
import com.kiy.wcms.util.AjaxUtil;

@Controller
@RequestMapping("/order/")
public class OrderController {
	@Autowired
	private OrderService orderService;
	@Autowired
	private UserService userService;
	/**
	 * 跳转到订单录入页面
	 * @return
	 */
	@RequestMapping("orderInput")
	public String orderInput(){
		return "/app/order/order_entering_list";
	}
	
	/**
	 * 获取订单列表
	 * @param param
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("getOrderList")
	public void getOrderList(Integer page, Integer rows, OrderParam param, HttpServletResponse response) throws IOException{
		if(page==null){
			page = 1;
		}
		if(rows==null){
			rows = 10;
		}
		int begin = (page-1) * rows;
		param.setBegin(begin);
		param.setRows(rows);
		JSONObject json = orderService.getOrderList(param);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 保存订单
	 * @param order
	 * @param response
	 */
	@RequestMapping("saveOrder")
	public void saveOrder(Order order, HttpServletResponse response, HttpServletRequest request){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		order.setCreateUser(user);
		orderService.saveOrder(order);
		JSONObject json = new JSONObject();
		json.put("flag", true);
		json.put("data", JSONObject.fromObject(order));
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 更新订单
	 * @param order
	 * @param response
	 */
	@RequestMapping("updateOrder")
	public void updateOrder(Order order, HttpServletResponse response){
		boolean flag = orderService.updateOrder(order);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 保存订单明细
	 * @param detail
	 * @param response
	 */
	@RequestMapping("saveOrderDetail")
	public void saveOrderDetail(OrderDetail detail, HttpServletResponse response){
		boolean flag = orderService.saveOrderDetail(detail);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取订单详情产品清单
	 * @param orderId
	 * @param response
	 */
	@RequestMapping("getOrderDetailList")
	public void getOrderDetailList(String orderId, HttpServletResponse response){
		JSONArray array = orderService.getOrderDetailList(orderId);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 删除订单明细信息
	 * @param detailId
	 * @param response
	 */
	@RequestMapping("deleteOrderDetail")
	public void deleteOrderDetail(String detailId, HttpServletResponse response){
		boolean flag = orderService.deleteOrderDetail(detailId);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 更新产品明细信息
	 * @param orderDetail
	 * @param response
	 */
	@RequestMapping("updateOrderDetail")
	public void updateOrderDetail(OrderDetail orderDetail, HttpServletResponse response){
		boolean flag = orderService.updateOrderDetail(orderDetail);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 上传订单附件
	 * @param orderId
	 * @param file
	 * @param request
	 * @param response
	 */
	@RequestMapping("addAtta")
	public void addAtta(String orderId, @RequestParam MultipartFile file, 
			HttpServletRequest request, HttpServletResponse response){
		String path = request.getSession().getServletContext().getRealPath("upload");
		path += File.separator + "order" + File.separator + new SimpleDateFormat("yyyy").format(new Date()) + File.separator + orderId;
		String filename = file.getOriginalFilename();
		File targetFile = new File(path, filename);
		
		int count = 1;
		while(targetFile.exists()){
			targetFile = new File(path + File.separator + "(" + count + ")" + filename);
			count++;
		}
		
		if(!targetFile.exists()){
			targetFile.mkdirs();
		}
		
		try {
			file.transferTo(targetFile);
			boolean flag = orderService.saveOrderAtta(orderId, targetFile.getPath(), targetFile.getName());
			JSONObject json = new JSONObject();
			json.put("flag", flag);
			AjaxUtil.outputJson(response, json);
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 获取订单附件列表
	 * @param orderId
	 * @param response
	 */
	@RequestMapping("getOrderAttaList")
	public void getOrderAttaList(String orderId, HttpServletResponse response){
		JSONArray array = orderService.getOrderAttaList(orderId);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 删除订单附件
	 * @param attaId
	 * @param response
	 */
	@RequestMapping("deleteOrderAtta")
	public void deleteOrderAtta(String attaId, HttpServletResponse response){
		boolean flag = orderService.deleteOrderAtta(attaId);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	@RequestMapping("downloadOrderAtta")
	public void downloadOrderAtta(String attaId, HttpServletResponse response){
		OutputStream out = null;
        
		String attaPath = orderService.getAttaPath(attaId);
		
		try {
			File file = new File(attaPath);
			response.reset();  
	        response.setHeader("Content-Disposition", "attachment; filename="+ URLEncoder.encode(file.getName(), "UTF-8"));  
	        response.setContentType("application/octet-stream; charset=utf-8");
	        out = response.getOutputStream();
	        out.write(FileUtils.readFileToByteArray(file));
	        
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally{
			if(out != null){
				try {
					out.flush();
					out.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	/**
	 * 提交订单
	 * @param id
	 * @param response
	 */
	@RequestMapping("submitOrder")
	public void submitOrder(String id, HttpServletResponse response, HttpServletRequest request){
		boolean flag = orderService.submitOrder(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 删除订单
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteOrder")
	public void deleteOrder(String id, HttpServletResponse response){
		boolean flag = orderService.deleteOrder(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到订单审批页面
	 * @param request
	 * @return
	 */
	@RequestMapping("orderAudit")
	public String orderAudit(HttpServletRequest request, Model model){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		//是否为销售部领导
		boolean isXSBLD = userService.isHasRole(user, "XSBLD");
		//是否为财务部领导
		boolean isCWBLD = userService.isHasRole(user, "CWBLD");
		
		String seeStatus = "";
		if(isXSBLD){
			seeStatus = "10";
		}else if(isCWBLD){
			seeStatus = "20";
		}
		model.addAttribute("seeStatus", seeStatus);
		return "/app/order/order_approval_list";
	}
	
	/**
	 * 获取订单审批列表
	 * @param seeStatus   10表示销售部   20表示财务部
	 * @param auditStatus 0:未审批   销售部查看状态为  10的   财务部查看状态为20的
	 *                    1：已审批  销售部查看状态大于10的  财务部查看状态大于20的
	 * @param response
	 */
	@RequestMapping("getOrderAuditList")
	public void getOrderAuditList(Integer page, Integer rows, OrderParam orderParam, String seeStatus, Integer auditStatus, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		
		if(rows == null){
			rows = 10;
		}
		
		int begin = (page-1) * rows;
		
		orderParam.setBegin(begin);
		orderParam.setRows(rows);
		
		if(auditStatus == null){
			auditStatus = 0;//未审批    销售部查看状态为  10的   财务部查看状态为20的
		}else if(auditStatus!=0){
			auditStatus = 1;//已审批  销售部查看状态大于10的  财务部查看状态大于20的
		}
		
		JSONObject json = orderService.getOrderAuditList(orderParam, seeStatus, auditStatus);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 提交审批
	 * @param id
	 * @param option
	 * @param seeStatus
	 * @param response
	 * @param request
	 */
	@RequestMapping("submitAudit")
	public void submitAudit(String id, String option, String seeStatus, String comment,
			HttpServletResponse response, HttpServletRequest request){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		int status = 0;
		if("0".equals(option)){
			status = -5555;
		}else{
			status = 20;
			if("20".equals(seeStatus)){
				status = 30;
			}
		}
		boolean flag = orderService.submitAudit(id, option, status, comment, user);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
}
