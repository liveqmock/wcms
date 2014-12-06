package com.kiy.wcms.entrepot.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.entrepot.entity.Shelf;

public interface ShelfMapper {
	/**
	 * 根据仓库获取货架列表
	 * @param begin
	 * @param rows
	 * @param eid
	 * @return
	 */
	public List<Shelf> getShelfsByEid(@Param("begin")int begin, @Param("rows")Integer rows, 
			@Param("eid")String eid);
	
	/**
	 * 根据仓库获取货架总数
	 * @param eid
	 * @return
	 */
	public int getTotalByEid(String eid);
	
	/**
	 * 新增货架
	 * @param shelf
	 */
	public void save(Shelf shelf);
	
	/**
	 * 更新货架
	 * @param shelf
	 */
	public void update(Shelf shelf);
	
	/**
	 * 删除货架
	 * @param id
	 */
	public void delete(String id);
	
	/**
	 * 根据仓库获取所有货架
	 * @param eid
	 * @return
	 */
	public List<Shelf> getAllShelfsByEid(String eid);
	
}
