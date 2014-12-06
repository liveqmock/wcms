package com.kiy.wcms.sys.service;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import net.sf.json.JSONArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.entity.UserTree;
import com.kiy.wcms.sys.mapper.SysUserMapper;
import com.kiy.wcms.util.SecurityUtil;

@Transactional
@Service("userService")
public class UserService {
	@Autowired
	private SysUserMapper sysUserMapper;
	
	/**
	 * 登陆
	 * @param username
	 * @param password
	 * @return
	 * @throws NoSuchAlgorithmException 
	 * @throws UnsupportedEncodingException 
	 */
	public SysUser login(String username, String password) throws UnsupportedEncodingException, NoSuchAlgorithmException{
		SysUser user = sysUserMapper.getUserByUsername(username);
		if(user!=null){
			if(!SecurityUtil.MD5(user.getSalt()+password).equals(user.getPassword())){
				user = null;
			}
		}
		return user;
	}

	/**
	 * 修改密码
	 * @param user
	 * @param newpass
	 * @return
	 * @throws NoSuchAlgorithmException 
	 * @throws UnsupportedEncodingException 
	 */
	public boolean modifyPwd(SysUser user, String newpass) throws UnsupportedEncodingException, NoSuchAlgorithmException {
		user.setPassword(SecurityUtil.MD5(user.getSalt()+newpass));
		sysUserMapper.update(user);
		return true;
	}
	
	/**
	 * 根据角色获取用户
	 * @param roleCode
	 * @return
	 */
	public JSONArray getUsersByRole(String roleCode) {
		List<UserTree> users = sysUserMapper.getUsersByRole(roleCode);
		return JSONArray.fromObject(users);
	}
	
	/**
	 * 根据角色获取用户名
	 * @param roles
	 * @return
	 */
	public String getUsernamesByRole(String roles) {
		List<String> list = sysUserMapper.getUsernamesByRole(roles);
		String users = "";
		for(String s : list){
			users += s + ",";
		}
		
		if(users.endsWith(",")){
			users = users.substring(0, users.length()-1);
		}
		return users;
	}
	
	/**
	 * 是否拥有某角色
	 * @param string
	 * @return
	 */
	public boolean isHasRole(SysUser user, String roleCode) {
		List<String> roles = sysUserMapper.getUserRoleCodes(user.getId());
		return roles.contains(roleCode);
	}
	
	/**
	 * 获取所有用户
	 * @return
	 */
	public JSONArray getAllUser() {
		List<UserTree> list = sysUserMapper.getAllUser();
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 是否拥有菜单权限
	 * @param menuId
	 * @param menusIds
	 * @return
	 */
	public boolean isHasPermission(int menuId, List<Integer> menusIds){
		return menusIds.contains(menuId);
	}
}
