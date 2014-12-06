package com.kiy.wcms.sys.mapper;

import java.util.List;

import com.kiy.wcms.sys.entity.Menu;

public interface MenuMapper {
	/**
	 * 根据登陆用户 获取所有可见菜单
	 * @param id
	 * @return
	 */
	public List<Menu> findAllMenus(int id);
	
	/**
	 * 获取所有一级菜单
	 * @return
	 */
	public List<Menu> getAllParentMenus();
	
	/**
	 * 根据父ID获取所有菜单
	 * @param pid
	 * @return
	 */
	public List<Menu> getMenusByPid(int pid);
	
	/**
	 * 保存菜单
	 * @param menu
	 */
	public void save(Menu menu);
	
	/**
	 * 更新菜单
	 * @param menu
	 */
	public void update(Menu menu);
	
	/**
	 * 删除菜单
	 * @param id
	 */
	public void delete(int id);
	/**
	 * 删除角色菜单数据
	 * @param id
	 */
	public void deleteRoleMenu(int id);
	/**
	 * 获取所有菜单ID
	 * @param id
	 * @return
	 */
	public List<Integer> getAllMenuIds(int userId);
}
