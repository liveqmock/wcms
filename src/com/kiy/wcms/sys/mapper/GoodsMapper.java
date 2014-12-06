package com.kiy.wcms.sys.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.sys.entity.Goods;

public interface GoodsMapper {
	/**
	 * 根据类别获取物品
	 * @param begin
	 * @param rows
	 * @param tid  类别
	 * @return
	 */
	public List<Goods> getGoodsByTid(@Param("begin")int begin, @Param("rows")Integer rows, 
			@Param("tid")String tid, @Param("name")String name, @Param("code")String code, 
			@Param("model")String model, @Param("brand")String brand);
	
	/**
	 * 获取类别下物品总数
	 * @param tid
	 * @return
	 */
	public int getTotal(@Param("tid")String tid, @Param("name")String name, @Param("code")String code, 
			@Param("model")String model, @Param("brand")String brand);
	
	/**
	 * 新增物品
	 * @param goods
	 */
	public void addGoods(Goods goods);
	
	/**
	 * 获取相同物品总数
	 * @param goods
	 * @return
	 */
	public int countGoods(Goods goods);

}
