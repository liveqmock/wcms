package com.kiy.wcms.sys.service;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kiy.wcms.sys.entity.DepartTree;
import com.kiy.wcms.sys.entity.Department;
import com.kiy.wcms.sys.entity.Goods;
import com.kiy.wcms.sys.entity.GoodsType;
import com.kiy.wcms.sys.entity.Menu;
import com.kiy.wcms.sys.entity.MenuTree;
import com.kiy.wcms.sys.entity.Role;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.entity.Unit;
import com.kiy.wcms.sys.mapper.DepartMapper;
import com.kiy.wcms.sys.mapper.GoodsMapper;
import com.kiy.wcms.sys.mapper.GoodsTypeMapper;
import com.kiy.wcms.sys.mapper.MenuMapper;
import com.kiy.wcms.sys.mapper.RoleMapper;
import com.kiy.wcms.sys.mapper.SysUserMapper;
import com.kiy.wcms.sys.mapper.UnitMapper;
import com.kiy.wcms.util.PageView;
import com.kiy.wcms.util.SecurityUtil;

@Transactional
@Service("sysService")
public class SysService {
	@Autowired
	private MenuMapper menuMapper;
	@Autowired
	private RoleMapper roleMapper;
	@Autowired
	private DepartMapper departMapper;
	@Autowired
	private SysUserMapper sysUserMapper;
	@Autowired
	private UnitMapper unitMapper;
	@Autowired
	private GoodsTypeMapper goodsTypeMapper;
	@Autowired
	private GoodsMapper goodsMapper;
	/**
	 * 获取用户所有菜单
	 * @param user
	 * @return
	 */
	public JSONArray getAllMenus(SysUser user) {
		List<Menu> list =  menuMapper.findAllMenus(user.getId());
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 获取所有菜单ID
	 * @param user
	 * @return
	 */
	public List<Integer> getAllMenuIds(SysUser user){
		return menuMapper.getAllMenuIds(user.getId());
	}
	
	/**
	 * 获取所有一级菜单
	 * @return
	 */
	public JSONArray getAllParentMenus() {
		List<Menu> list = menuMapper.getAllParentMenus();
		return JSONArray.fromObject(list);
	}

	/**
	 * 根据父菜单获取所有下属菜单
	 * @param pid
	 * @return
	 */
	public JSONArray getMenusByPid(int pid) {
		List<Menu> list = menuMapper.getMenusByPid(pid);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 保存菜单
	 * @param menu
	 * @return
	 */
	public boolean saveMenu(Menu menu) {
		if(menu.getPid() != 0){
			menu.setLevel(1);
		}else {
			menu.setLevel(0);
		}
		menuMapper.save(menu);
		return true;
	}

	/**
	 * 更新菜单
	 * @param menu
	 * @return
	 */
	public boolean updateMenu(Menu menu) {
		menuMapper.update(menu);
		return true;
	}
	
	/**
	 * 删除菜单
	 * @param id
	 * @return
	 */
	public boolean deleteMenu(int id) {
		menuMapper.deleteRoleMenu(id);
		menuMapper.delete(id);
		return true;
	}
	
	/**
	 * 获取角色列表
	 * @param page
	 * @param rows
	 * @return
	 */
	public JSONObject getRoleList(Integer page, Integer rows) {
		int begin = (page-1) * rows;
		List<Role> list = roleMapper.getRoleList(begin, rows);
		int total = roleMapper.getTotal();
		PageView pageView = new PageView(total, list);
		return JSONObject.fromObject(pageView);
	}
	
	/**
	 * 保存角色
	 * @param role
	 * @return
	 */
	public boolean saveRole(Role role) {
		roleMapper.save(role);
		return true;
	}
	
	/**
	 * 更新角色
	 * @param role
	 * @return
	 */
	public boolean updateRole(Role role) {
		roleMapper.update(role);
		return true;
	}
	
	/**
	 * 删除角色
	 * @param id
	 * @return
	 */
	public boolean deleteRole(int id) {
		//删除role_menu数据
		//删除user_role数据
		roleMapper.deleteRoleMenu(id);
		roleMapper.deleteUserRole(id);
		roleMapper.deleteRole(id);
		return true;
	}
	
	/**
	 * 获取角色权限展现数据
	 * @return
	 */
	public JSONArray getRoleAction(int roleId) {
		List<MenuTree> menus = roleMapper.getAllMenu();
		List<Integer> hadMenus = roleMapper.getHadMenus(roleId);
		for(MenuTree m : menus){
			if(hadMenus.contains(m.getId())){
				m.setChecked(true);
				if(m.getChildren() != null){
					for(MenuTree mt : m.getChildren()){
						if(hadMenus.contains(mt.getId())){
							mt.setChecked(true);
						}
					}
				}
			}
		}
		return JSONArray.fromObject(menus);
	}
	
	/**
	 * 保存用户菜单
	 * @param menuIds
	 * @return
	 */
	public boolean saveRoleMenus(String menuIds, int roleId) {
		String[] ids = menuIds.split(",");
		List<String> idList = Arrays.asList(ids);
		//先删除  再插入
		roleMapper.deleteRoleMenu(roleId);
		roleMapper.saveRoleMenu(idList, roleId);
		return true;
	}
	
	/**
	 * 获取部门树结构
	 * @return
	 */
	public JSONArray getDeptTree() {
		List<DepartTree> depts = departMapper.getDeptTree();
		return JSONArray.fromObject(depts);
	}
	
	/**
	 * 根据父ID获取部门
	 * @return
	 */
	public JSONArray getDeptsByPid(int pid) {
		List<Department> depts = departMapper.getDeptsByPid(pid);
		return JSONArray.fromObject(depts);
	}

	/**
	 * 保存部门
	 * @param dept
	 * @return
	 */
	public boolean saveDept(Department dept) {
		dept.setIsDisable(0);
		departMapper.save(dept);
		return true;
	}
	
	/**
	 * 更新部门
	 * @param dept
	 * @return
	 */
	public boolean updateDept(Department dept) {
		departMapper.update(dept);
		return true;
	}
	
	/**
	 * 获取部门所有用户
	 * @param deptId
	 * @param page
	 * @param rows
	 * @return
	 */
	public JSONObject getUsersByDeptId(String deptId, Integer page, Integer rows) {
		int begin = (page -1) * rows;
		List<SysUser> users = sysUserMapper.getUsersByDeptId(deptId, begin, rows);
		int total = sysUserMapper.getTotal(deptId);
		PageView pageView = new PageView(total, users);
		return JSONObject.fromObject(pageView);
	}
	
	/**
	 * 保存用户
	 * @param user
	 * @return
	 * @throws NoSuchAlgorithmException 
	 * @throws UnsupportedEncodingException 
	 */
	public boolean saveUser(SysUser user) throws UnsupportedEncodingException, NoSuchAlgorithmException {
		char[] arr = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
		Random random = new Random();
		StringBuffer sb = new StringBuffer();
		for(int i=0;i<6;i++){
			sb.append(arr[random.nextInt(arr.length-1)]);
		}
		user.setSalt(sb.toString());
		user.setPassword(SecurityUtil.MD5(user.getSalt() + user.getPassword()));
		sysUserMapper.save(user);
		return true;
	}
	
	/**
	 * 更新用户
	 * @param user
	 * @return
	 */
	public boolean updateUser(SysUser user) {
		sysUserMapper.updateUser(user);
		return true;
	}
	
	/**
	 * 重置密码
	 * @param user
	 * @return
	 * @throws NoSuchAlgorithmException 
	 * @throws UnsupportedEncodingException 
	 */
	public boolean reloadPwd(SysUser user) throws UnsupportedEncodingException, NoSuchAlgorithmException {
		user.setPassword(SecurityUtil.MD5(user.getSalt() + user.getPassword()));
		sysUserMapper.reloadPwd(user);
		return true;
	}
	
	/**
	 * 获取展现的用户角色数据
	 * @param selectUser
	 * @return
	 */
	public JSONArray getUserRoleList(String selectUser) {
		List<Role> roles = roleMapper.getAllRole();
		List<Integer> had = sysUserMapper.getUserAllRole(selectUser);
		for(Role r : roles){
			if(had.contains(r.getId())){
				r.setIsHas(true);
			}
		}
		return JSONArray.fromObject(roles);
	}
	
	/**
	 * 保存用户角色
	 * @param roleIds
	 * @param userId
	 * @return
	 */
	public boolean saveUserRoles(String roleIds, String userId) {
		String[] ids = roleIds.split(",");
		List<String> idList = Arrays.asList(ids);
		//先删除  再插入
		sysUserMapper.deleteUserRoles(userId);
		sysUserMapper.saveUserRoles(idList, userId);
		return true;
	}
	
	/**
	 * 获取单位列表
	 * @param page
	 * @param rows
	 * @return
	 */
	public JSONObject getUnitList(Integer page, Integer rows) {
		int begin = (page-1) * rows;
		List<Unit> list = unitMapper.getUnitList(begin, rows);
		Integer total = unitMapper.getTotal();
		PageView view = new PageView(total, list);
		return JSONObject.fromObject(view);
	}
	
	/**
	 * 保存单位
	 * @param unit
	 * @return
	 */
	public boolean saveUnit(Unit unit) {
		unitMapper.save(unit);
		return true;
	}
	
	/**
	 * 获取所有单位
	 * @return
	 */
	public JSONArray getAllUnit() {
		List<Unit> list = unitMapper.getAllUnit();
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 获取物品类别列表
	 * @param begin
	 * @param rows
	 * @return
	 */
	public JSONArray getParentGoodsTypeList() {
		List<GoodsType> list = goodsTypeMapper.getParentList();
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 根据PID获取类别列表
	 * @param pid
	 * @return
	 */
	public JSONArray getGoodsTypeList(String pid) {
		List<GoodsType> list = goodsTypeMapper.getGoodsTypeList(pid);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 新增物品类别
	 * @param goodsType
	 * @return
	 */
	public boolean addGoodsType(GoodsType goodsType) {
		goodsTypeMapper.save(goodsType);
		return true;
	}
	
	/**
	 * 获取物品类别树结构
	 * @return
	 */
	public JSONArray getGoodsTypeTree() {
		List<GoodsType> list = goodsTypeMapper.getList();
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 根据类别获取物品
	 * @param begin
	 * @param rows
	 * @param tid  类别ID
	 * @return
	 */
	public JSONObject getGoodsByTid(int begin, Integer rows, String tid,
			String name, String code, String model, String brand) {
		List<Goods> list = goodsMapper.getGoodsByTid(begin, rows, tid, name, code, model, brand);
		int total = goodsMapper.getTotal(tid, name, code, model, brand);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 新增物品
	 * @param goods
	 * @return
	 */
	public boolean addGoods(Goods goods) {
		goodsMapper.addGoods(goods);
		return true;
	}
	
	/**
	 * 判断物品是否已存在
	 * @param goods
	 * @return  true:存在   false:不存在
	 */
	public boolean isGoodsExists(Goods goods) {
		int count = goodsMapper.countGoods(goods);
		return count!=0;
	}
}
