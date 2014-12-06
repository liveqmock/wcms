package com.kiy.wcms.sys.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.sys.entity.MenuTree;
import com.kiy.wcms.sys.entity.Role;

public interface RoleMapper {
	/**
	 * 获取角色列表
	 * @param begin
	 * @param rows
	 * @return
	 */
	public List<Role> getRoleList(@Param("begin")int begin, @Param("rows")Integer rows);
	
	/**
	 * 保存角色
	 * @param role
	 */
	public void save(Role role);
	
	/**
	 * 更新角色
	 * @param role
	 */
	public void update(Role role);

	public void deleteRoleMenu(int id);

	public void deleteUserRole(int id);

	public void deleteRole(int id);
	
	/**
	 * 获取所有菜单
	 * @return
	 */
	public List<MenuTree> getAllMenu();
	/**
	 * 获取目标角色已拥有的菜单
	 * @param roleId
	 * @return
	 */
	public List<Integer> getHadMenus(int roleId);
	
	/**
	 * 批量插入角色菜单数据
	 * @param idList
	 * @param roleId
	 */
	public void saveRoleMenu(@Param("idList")List<String> idList, @Param("roleId")int roleId);
	/**
	 * 获取总条数
	 * @return
	 */
	public int getTotal();

	public List<Role> getAllRole();

}
