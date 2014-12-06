package com.kiy.wcms.design.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.design.entity.MaterialList;

public interface MaterialListMapper {
	/**
	 * 保存物料
	 * @param mater
	 */
	public void save(MaterialList mater);
	
	/**
	 * 获取物料清单
	 * @param begin
	 * @param rows
	 * @param id
	 * @return
	 */
	public List<MaterialList> getMaterList(@Param("begin")int begin, @Param("rows")Integer rows, 
			@Param("id")String id);
	
	/**
	 * 获取物料总数
	 * @param id
	 * @return
	 */
	public int getTotal(String id);
	
	/**
	 * 更新物料
	 * @param mater
	 */
	public void update(MaterialList mater);
	
	/**
	 * 删除物料
	 * @param id
	 */
	public void delete(String id);

}
