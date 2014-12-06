package com.kiy.wcms.sys.controller;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kiy.wcms.Global;
import com.kiy.wcms.design.service.DesignService;
import com.kiy.wcms.gather.service.GatherService;
import com.kiy.wcms.order.service.OrderService;
import com.kiy.wcms.procurementplan.service.ContractService;
import com.kiy.wcms.procurementplan.service.PaymentService;
import com.kiy.wcms.procurementplan.service.ProcurementPlanService;
import com.kiy.wcms.producplan.service.ProducPlanService;
import com.kiy.wcms.sys.entity.Department;
import com.kiy.wcms.sys.entity.Goods;
import com.kiy.wcms.sys.entity.GoodsType;
import com.kiy.wcms.sys.entity.Menu;
import com.kiy.wcms.sys.entity.Role;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.entity.ToDo;
import com.kiy.wcms.sys.entity.Unit;
import com.kiy.wcms.sys.service.SysService;
import com.kiy.wcms.sys.service.UserService;
import com.kiy.wcms.util.AjaxUtil;

@Controller
@RequestMapping("/sys/")
public class SysController {
	@Autowired
	private SysService sysService;
	@Autowired
	private UserService userService;
	@Autowired
	private OrderService orderService;
	@Autowired
	private ProducPlanService producPlanService;
	@Autowired
	private DesignService designService;
	@Autowired
	private GatherService gatherService;
	@Autowired
	private ProcurementPlanService procurementPlanService;
	@Autowired
	private ContractService contractService;
	@Autowired
	private PaymentService paymentService;
	/**
	 * 获取用户所有菜单
	 * @param response
	 * @param request
	 * @throws IOException
	 */
	@RequestMapping("getSysMenus")
	public void getSysMenus(HttpServletResponse response, HttpServletRequest request) throws IOException{
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		JSONArray array = sysService.getAllMenus(user);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 跳转到菜单管理页面
	 * @param model
	 * @return
	 */
	@RequestMapping("menuManager")
	public String menuManager(Model model){
		return "/app/sys/menu_manager";
	}
	
	/**
	 * 获取所有一级菜单
	 * @throws IOException 
	 */
	@RequestMapping("getParentMenus")
	public void getParentMenus(HttpServletResponse response) throws IOException{
		JSONArray array = sysService.getAllParentMenus();
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 根据父ID获取所有下属菜单
	 * @param pid
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("getMenusByPid")
	public void getMenusByPid(int pid, HttpServletResponse response) throws IOException{
		JSONArray array = sysService.getMenusByPid(pid);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 保存菜单
	 * @param menu
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("saveMenu")
	public void saveMenu(Menu menu, HttpServletResponse response) throws IOException{
		boolean flag = sysService.saveMenu(menu);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 更新菜单
	 * @param menu
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("updateMenu")
	public void updateMenu(Menu menu, HttpServletResponse response) throws IOException{
		boolean flag = sysService.updateMenu(menu);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 删除菜单
	 * @param id
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("deleteMenu")
	public void deleteMenu(int id, HttpServletResponse response) throws IOException{
		boolean flag = sysService.deleteMenu(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到角色管理页面
	 * @return
	 */
	@RequestMapping("roleManager")
	public String roleManager(){
		return "/app/sys/role_manager";
	}
	
	/**
	 * 获取所有角色列表
	 * @param page
	 * @param rows
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("getRoleList")
	public void getRoleList(Integer page, Integer rows, HttpServletResponse response) throws IOException{
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		
		JSONObject json = sysService.getRoleList(page, rows);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 保存角色
	 * @param role
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("saveRole")
	public void saveRole(Role role, HttpServletResponse response) throws IOException{
		boolean flag = sysService.saveRole(role);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 保存角色
	 * @param role
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("updateRole")
	public void updateRole(Role role, HttpServletResponse response) throws IOException{
		boolean flag = sysService.updateRole(role);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 删除角色
	 * @param id
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("deleteRole")
	public void deleteRole(int id, HttpServletResponse response) throws IOException{
		boolean flag = sysService.deleteRole(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取权限展示数据
	 * @param roleId
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("getRoleAction")
	public void getRoleAction(int roleId, HttpServletResponse response) throws IOException{
		JSONArray array = sysService.getRoleAction(roleId);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 保存角色菜单
	 * @param menuIds
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("saveRoleMenus")
	public void saveRoleMenus(String menuIds, Integer roleId, HttpServletResponse response) throws IOException{
		boolean flag = sysService.saveRoleMenus(menuIds, roleId);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到部门管理界面
	 * @return
	 */
	@RequestMapping("deptManager")
	public String deptManager(){
		return "/app/sys/dept_manager";
	}
	
	/**
	 * 获取部门树结构
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("getDeptTree")
	public void getDeptTree(HttpServletResponse response) throws IOException{
		JSONArray array = sysService.getDeptTree();
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 根据父ID获取部门
	 * @param pid
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("getDeptsByPid")
	public void getDeptsByPid(int pid, HttpServletResponse response) throws IOException{
		JSONArray array = sysService.getDeptsByPid(pid);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 保存部门
	 * @param dept
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("saveDept")
	public void saveDept(Department dept, HttpServletResponse response) throws IOException{
		boolean flag = sysService.saveDept(dept);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 更新部门
	 * @param dept
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("updateDept")
	public void updateDept(Department dept, HttpServletResponse response) throws IOException{
		boolean flag = sysService.updateDept(dept);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到用户管理页面
	 * @return
	 */
	@RequestMapping("userManager")
	public String userManager(){
		return "/app/sys/user_manager";
	}
	
	/**
	 * 获取部门所有用户
	 * @param deptId
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("getUsersByDeptId")
	public void getUsersByDeptId(Integer page, Integer rows, String deptId, HttpServletResponse response) throws IOException{
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		JSONObject json = sysService.getUsersByDeptId(deptId, page, rows);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 保存用户
	 * @param user
	 * @param response
	 * @throws IOException 
	 * @throws NoSuchAlgorithmException 
	 */
	@RequestMapping("saveUser")
	public void saveUser(SysUser user, HttpServletResponse response) throws IOException, NoSuchAlgorithmException{
		boolean flag = sysService.saveUser(user);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 更新用户
	 * @param user
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("updateUser")
	public void updateUser(SysUser user, HttpServletResponse response) throws IOException{
		boolean flag = sysService.updateUser(user);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 重置密码
	 * @param user
	 * @param response
	 * @throws IOException 
	 * @throws NoSuchAlgorithmException 
	 */
	@RequestMapping("reloadPwd")
	public void reloadPwd(SysUser user, HttpServletResponse response) throws IOException, NoSuchAlgorithmException{
		boolean flag = sysService.reloadPwd(user);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取展现的用户角色数据
	 * @param selectUser
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("getUserRoleList")
	public void getUserRoleList(String selectUser, HttpServletResponse response) throws IOException{
		JSONArray array = sysService.getUserRoleList(selectUser);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 保存用户角色
	 * @param roleIds
	 * @param userId
	 * @param response
	 * @throws IOException 
	 */
	@RequestMapping("saveUserRoles")
	public void saveUserRoles(String roleIds, String userId, HttpServletResponse response) throws IOException{
		boolean flag = sysService.saveUserRoles(roleIds, userId);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到单位管理页面
	 * @return
	 */
	@RequestMapping("unitManager")
	public String unitManager(){
		return "/app/sys/unit_manager";
	}
	
	/**
	 * 获取单位列表
	 * @param page
	 * @param rows
	 * @param response
	 */
	@RequestMapping("getUnitList")
	public void getUnitList(Integer page, Integer rows, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		
		JSONObject json = sysService.getUnitList(page, rows);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取所有单位
	 * @param response
	 */
	@RequestMapping("getAllUnit")
	public void getAllUnit(HttpServletResponse response){
		JSONArray array = sysService.getAllUnit();
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 保存单位
	 * @param unit
	 * @param response
	 */
	@RequestMapping("saveUnit")
	public void saveUnit(Unit unit, HttpServletResponse response){
		boolean flag = sysService.saveUnit(unit);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到物品类别管理页面
	 * @return
	 */
	@RequestMapping("goodsTypeManager")
	public String goodsTypeManager(){
		return "/app/sys/goods_type_manager";
	}
	
	/**
	 * 获取物品类别列表
	 * @param response
	 */
	@RequestMapping("getParentGoodsTypeList")
	public void getParentGoodsTypeList(HttpServletResponse response){
		JSONArray array = sysService.getParentGoodsTypeList();
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 根据PID获取物品类别列表
	 * @param pid
	 * @param response
	 */
	@RequestMapping("getGoodsTypeListByPid")
	public void getGoodsTypeListByPid(String pid, HttpServletResponse response){
		JSONArray array = sysService.getGoodsTypeList(pid);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 新增物品类别
	 * @param goodsType
	 * @param response
	 */
	@RequestMapping("addGoodsType")
	public void addGoodsType(GoodsType goodsType, HttpServletResponse response){
		if(goodsType.getPid() == 0){
			goodsType.setPid(null);
		}
		boolean flag = sysService.addGoodsType(goodsType);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取物品类别树结构
	 * @param response
	 */
	@RequestMapping("getGoodsTypeTree")
	public void getGoodsTypeTree(HttpServletResponse response){
		JSONArray array = sysService.getGoodsTypeTree();
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 根据类别获取物品
	 * @param tid
	 */
	@RequestMapping("getGoodsByTid")
	public void getGoodsByTid(Integer page, Integer rows, String tid, 
			String name, String code, String model, String brand,
			HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		int begin = (page - 1) * rows;
		JSONObject json = sysService.getGoodsByTid(begin, rows, tid, name, code, model, brand);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 新增物品
	 * @param goods
	 * @param response
	 */
	@RequestMapping("addGoods")
	public void addGoods(Goods goods, HttpServletResponse response){
		JSONObject json = new JSONObject();
		boolean flag = sysService.isGoodsExists(goods);
		if(!flag){
			flag = sysService.addGoods(goods);
		}else{
			flag = false;
			json.put("msg", "该物品已存在");
		}
		
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取待办事项
	 * @param request
	 * @param response
	 */
	@RequestMapping("getToDo")
	public void getToDo(HttpServletRequest request, HttpServletResponse response){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		List<Integer> menusIds = sysService.getAllMenuIds(user);
		List<ToDo> todos = new ArrayList<ToDo>();
		
		//订单被退回
		if(userService.isHasPermission(8, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("订单录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/order/orderInput");
			int total = orderService.getBackTotal();
			if(total > 0){
				todo.setName("订单被退回(" + total + ")");
				todos.add(todo);
			}
		}
		
		//订单待审批
		if(userService.isHasPermission(10, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("订单审批");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/order/orderAudit");
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
			int count = orderService.getToAuditCount(seeStatus);
			if(count > 0){
				todo.setName("订单待审批(" + count + ")");
				todos.add(todo);
			}
		}
		
		//生产计划被退回
		if(userService.isHasPermission(8, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("生产计划录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/producPlan/inputManager");
			int total = producPlanService.getBackTotal();
			if(total > 0){
				todo.setName("生产计划被退回(" + total + ")");
				todos.add(todo);
			}
		}
		
		//生产计划待提交
		if(userService.isHasPermission(16, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("生产计划录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/producPlan/inputManager");
			int total = producPlanService.getUnPayTotal();
			if(total > 0){
				todo.setName("生产计划待提交(" + total + ")");
				todos.add(todo);
			}
		}
		
		//生产计划待审批
		if(userService.isHasPermission(17, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("生产计划审批");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/producPlan/auditManager");
			
			//是否为销售部领导
			boolean isXSBLD = userService.isHasRole(user, "XSBLD");
			//是否为技术部领导
			boolean isJSBLD = userService.isHasRole(user, "JSBLD");
			//是否为采购部领导
			boolean isCGBLD = userService.isHasRole(user, "CGBLD");
			
			String seeStatus = "";
			if(isXSBLD){
				seeStatus = "10";
			}else if(isJSBLD){
				seeStatus = "20";
			}else if(isCGBLD){
				seeStatus = "25";
			}
			
			int total = producPlanService.getUnAuditTotal(seeStatus);
			if(total > 0){
				todo.setName("生产计划待审批(" + total + ")");
				todos.add(todo);
			}
		}
		
		//设计方案被退回
		if(userService.isHasPermission(18, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("设计方案录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/design/inputManager");
			int total = designService.getBackTotal();
			if(total > 0){
				todo.setName("设计方案被退回(" + total + ")");
				todos.add(todo);
			}
			
		}
		
		//设计方案待录入
		if(userService.isHasPermission(18, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("设计方案录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/design/inputManager");
			int total = designService.getUnPayTotal();
			if(total > 0){
				todo.setName("设计方案待录入(" + total + ")");
				todos.add(todo);
			}
		}
		
		//设计方案待审批
		if(userService.isHasPermission(19, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("设计方案审批");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/design/auditManager");
			
			//是否为技术部领导
			boolean isJSBLD = userService.isHasRole(user, "JSBLD");
			
			String seeStatus = "";
			if(isJSBLD){
				seeStatus = "10";
			}
			
			int total = designService.getUnAuditTotal(seeStatus);
			if(total > 0){
				todo.setName("设计方案待审批(" + total + ")");
				todos.add(todo);
			}
		}

		//订单待收款
		if(userService.isHasPermission(20, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("收款单录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/gather/gatherInputManager");
			int total = gatherService.getUnGatherTotal();
			if(total > 0){
				todo.setName("订单待收款(" + total + ")");
				todos.add(todo);
			}
		}
		
		//收款单被退回
		if(userService.isHasPermission(20, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("收款单录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/gather/gatherInputManager");
			int total = gatherService.getBackGatherTotal();
			if(total > 0){
				todo.setName("收款单被退回(" + total + ")");
				todos.add(todo);
			}
		}
		
		//收款单待审批
		if(userService.isHasPermission(21, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("收款单审批");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/gather/gatherAuditManager");
			
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
			
			int total = gatherService.getUnAuditGatherTotal(seeStatus);
			if(total > 0){
				todo.setName("收款单待审批(" + total + ")");
				todos.add(todo);
			}
		}
		
		//发货申请单被退回
		if(userService.isHasPermission(22, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("发货申请单录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/gather/shipmentsInput");
			
			int total = gatherService.getBackShipmentTotal();
			if(total > 0){
				todo.setName("发货申请单被退回(" + total + ")");
				todos.add(todo);
			}
		}
		
		//订单待发货
		if(userService.isHasPermission(22, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("发货申请单录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/gather/shipmentsInput");
			//TODO
//			int total = gatherService.getUnShipmentTotal();
//			if(total > 0){
//				todo.setName("订单待发货(" + total + ")");
//				todos.add(todo);
//			}
		}
		
		//发货申请单待审批
		if(userService.isHasPermission(23, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("发货申请单审批");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/gather/shipmentsAudit");
			
			//是否为销售部领导
			boolean isXSBLD = userService.isHasRole(user, "XSBLD");
			//是否为财务部领导
			boolean isCWBLD = userService.isHasRole(user, "CWBLD");
			//是否为生产部领导
			boolean isSCLD = userService.isHasRole(user, "SCLD");
			//是否为质检
			boolean isZJ = userService.isHasRole(user, "ZJ");
			
			String seeStatus = "";
			if(isXSBLD){
				seeStatus = "10";
			}else if(isCWBLD){
				seeStatus = "15";
			}else if(isSCLD){
				seeStatus = "20";
			}else if(isZJ){
				seeStatus = "25";
			}
			
			int total = gatherService.getUnAuditShipmentTotal(seeStatus);
			if(total > 0){
				todo.setName("发货申请单待审批(" + total + ")");
				todos.add(todo);
			}
		}
		
		//送货单待录入
		if(userService.isHasPermission(24, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("送货单录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/gather/deliveryInput");
			
			int total = gatherService.getUnPayDeliveryTotal();
			if(total > 0){
				todo.setName("送货单待录入(" + total + ")");
				todos.add(todo);
			}
		}
		
		//采购计划被退回
		if(userService.isHasPermission(26, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("采购计划录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/procurementPlan/procurementInput?pageType=list");
			
			int total = procurementPlanService.getBackTotal();
			if(total > 0){
				todo.setName("采购计划被退回(" + total + ")");
				todos.add(todo);
			}
		}
		
		//采购计划待审批
		if(userService.isHasPermission(27, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("采购计划审批");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/procurementPlan/procurementInput");
			
			//是否为采购部领导
			boolean isCGBLD = userService.isHasRole(user, "CGBLD");
			//是否为财务部领导
			boolean isCWBLD = userService.isHasRole(user, "CWBLD");
			
			String seeStatus = "";
			if(isCGBLD){
				seeStatus = "10";
			}else if(isCWBLD){
				seeStatus = "20";
			}
			
			int total = procurementPlanService.getUnAuditTotal(seeStatus);
			if(total > 0){
				todo.setName("采购计划待审批(" + total + ")");
				todos.add(todo);
			}
		}
		
		//采购订单待录入
//		if(userService.isHasPermission(28, menusIds)){
//			ToDo todo = new ToDo();
//			todo.setTitle("采购订单录入");
//			todo.setIcon("icon icon-nav");
//			todo.setUrl("/wcms/contract/contractInput");
//		}
		
		//采购订单被退回
		if(userService.isHasPermission(28, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("采购订单录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/contract/contractInput");
			
			int total = contractService.getBackTotal();
			if(total > 0){
				todo.setName("采购订单被退回(" + total + ")");
				todos.add(todo);
			}
		}
		
		//采购订单待审批
		if(userService.isHasPermission(29, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("采购订单审批");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/contract/contractAudit");
			
			//是否为采购部领导
			boolean isCGBLD = userService.isHasRole(user, "CGBLD");
			//是否为财务部领导
			boolean isCWBLD = userService.isHasRole(user, "CWBLD");
			
			String seeStatus = "";
			if(isCGBLD){
				seeStatus = "10";
			}else if(isCWBLD){
				seeStatus = "20";
			}
			
			int total = contractService.getUnAuditTotal(seeStatus);
			if(total > 0){
				todo.setName("采购订单待审批(" + total + ")");
				todos.add(todo);
			}
		}
		
		//待验收
//		if(userService.isHasPermission(30, menusIds)){
//			ToDo todo = new ToDo();
//			todo.setTitle("验收确认");
//			todo.setIcon("icon icon-nav");
//			todo.setUrl("/wcms/contract/accept");
//		}
		
		//采购订单待付款
		if(userService.isHasPermission(31, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("付款申请单录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/payment/paymentInput");
			
			int total = paymentService.getUnPayTotal();
			if(total > 0){
				todo.setName("采购订单待付款(" + total + ")");
				todos.add(todo);
			}
		}
		
		//付款申请单被退回
		if(userService.isHasPermission(31, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("付款申请单录入");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/payment/paymentInput");
			
			int total = paymentService.getBackTotal();
			if(total > 0){
				todo.setName("付款申请单被退回(" + total + ")");
				todos.add(todo);
			}
		}
		
		//付款申请单待审批
		if(userService.isHasPermission(32, menusIds)){
			ToDo todo = new ToDo();
			todo.setTitle("付款申请单审批");
			todo.setIcon("icon icon-nav");
			todo.setUrl("/wcms/payment/paymentAudit");
			
			//是否为采购部领导
			boolean isCGBLD = userService.isHasRole(user, "CGBLD");
			//是否为财务部领导
			boolean isCWBLD = userService.isHasRole(user, "CWBLD");
					
			String seeStatus = "";
			if(isCGBLD){
				seeStatus = "10";
			}else if(isCWBLD){
				seeStatus = "20";
			}
			
			int total = paymentService.getUnAuditTotal(seeStatus);
			if(total > 0){
				todo.setName("付款申请单待审批(" + total + ")");
				todos.add(todo);
			}
		}
		
		AjaxUtil.outputJsonArray(response, JSONArray.fromObject(todos));
	}
}
