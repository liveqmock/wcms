package com.kiy.wcms.sys.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.sys.entity.Unit;

public interface UnitMapper {
	/**
	 * 获取单位列表
	 * @param begin
	 * @param rows
	 * @return
	 */
	public List<Unit> getUnitList(@Param("begin")int begin, @Param("rows")int rows);
	/**
	 * 获取记录总数
	 * @return
	 */
	public Integer getTotal();
	/**
	 * 保存单位
	 * @param unit
	 */
	public void save(Unit unit);
	/**
	 * 获取所有单位
	 * @return
	 */
	public List<Unit> getAllUnit();
}
