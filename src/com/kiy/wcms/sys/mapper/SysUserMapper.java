package com.kiy.wcms.sys.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.entity.UserTree;

public interface SysUserMapper {
	public SysUser getUserByUsername(String username);

	public void update(SysUser user);
	
	/**
	 * 获取部门所有用户
	 * @param deptId
	 * @param page
	 * @param rows
	 * @return
	 */
	public List<SysUser> getUsersByDeptId(@Param("deptId")String deptId, 
			@Param("begin")Integer begin,
			@Param("rows")Integer rows);
	
	/**
	 * 获取部门用户总数
	 * @param deptId
	 * @return
	 */
	public int getTotal(String deptId);
	
	/**
	 * 保存用户
	 * @param user
	 */
	public void save(SysUser user);
	
	/**
	 * 更新用户
	 * @param user
	 */
	public void updateUser(SysUser user);
	
	/**
	 * 重置密码
	 * @param user
	 */
	public void reloadPwd(SysUser user);
	
	/**
	 * 获取已拥有的所有角色
	 * @return
	 */
	public List<Integer> getUserAllRole(String selectUser);
	
	/**
	 * 删除用户所有角色
	 * @param userId
	 */
	public void deleteUserRoles(String userId);

	/**
	 * 保存用户角色
	 * @param idList
	 * @param userId
	 */
	public void saveUserRoles(@Param("idList")List<String> idList, @Param("userId")String userId);
	
	/**
	 * 根据角色获取用户
	 * @param roleCode
	 * @return
	 */
	public List<UserTree> getUsersByRole(String roleCode);
	
	/**
	 * 根据角色获取用户名
	 * @param roles
	 * @return
	 */
	public List<String> getUsernamesByRole(String roles);
	/**
	 * 获取用户的所有角色编码
	 * @param id
	 * @return
	 */
	public List<String> getUserRoleCodes(int id);
	
	/**
	 * 获取所有用户
	 * @return
	 */
	public List<UserTree> getAllUser();
}
