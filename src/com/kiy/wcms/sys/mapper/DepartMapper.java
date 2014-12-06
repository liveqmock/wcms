package com.kiy.wcms.sys.mapper;

import java.util.List;

import com.kiy.wcms.sys.entity.DepartTree;
import com.kiy.wcms.sys.entity.Department;

public interface DepartMapper {
	/**
	 * 获取部门树结构
	 * @return
	 */
	public List<DepartTree> getDeptTree();
	
	/**
	 * 根据父ID获取部门
	 * @param pid
	 * @return
	 */
	public List<Department> getDeptsByPid(int pid);
	
	/**
	 * 保存部门
	 * @param dept
	 */
	public void save(Department dept);
	
	/**
	 * 更新部门
	 * @param dept
	 */
	public void update(Department dept);

}
