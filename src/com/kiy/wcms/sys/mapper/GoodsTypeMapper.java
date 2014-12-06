package com.kiy.wcms.sys.mapper;

import java.util.List;

import com.kiy.wcms.sys.entity.GoodsType;

public interface GoodsTypeMapper {
	/**
	 * 获取物品类别列表
	 * @param begin
	 * @param rows
	 * @return
	 */
	public List<GoodsType> getParentList();
	
	/**
	 * 获取物品类别总数
	 * @return
	 */
	public int getTotal();
	
	/**
	 * 根据PID获取物品类别列表
	 * @param pid
	 * @return
	 */
	public List<GoodsType> getGoodsTypeList(String pid);
	
	/**
	 * 新增物品类别
	 * @param goodsType
	 */
	public void save(GoodsType goodsType);
	
	/**
	 * 获取物品类别树结构
	 * @return
	 */
	public List<GoodsType> getList();

}
