package com.kiy.wcms.entrepot.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.entrepot.entity.Stock;

public interface StockMapper {
	/**
	 * 获取物品库存数
	 * @param goodsId      物品ID
	 * @param entrepotId   仓库ID
	 * @param shelfId      货架号ID
	 * @return
	 */
	public double getGoodsTotal(@Param("goodsId")int goodsId, @Param("entrepotId")int entrepotId, 
			@Param("shelfId")int shelfId);
	
	/**
	 * 新增库存
	 * @param stock
	 */
	public void save(Stock stock);
	
	/**
	 * 更新库存
	 * @param stock
	 */
	public void update(Stock stock);
	
	/**
	 * 查询库存情况
	 * @param begin
	 * @param rows
	 * @param tid
	 * @param name
	 * @param code
	 * @param model
	 * @param brand
	 * @return
	 */
	public List<Stock> getGoodsStockByTid(@Param("begin")int begin, @Param("rows")Integer rows, 
			@Param("tid")String tid, @Param("name")String name, @Param("code")String code, 
			@Param("model")String model, @Param("brand")String brand);
	
	/**
	 * 查询库存总数
	 * @param tid
	 * @param name
	 * @param code
	 * @param model
	 * @param brand
	 * @return
	 */
	public int getGoodsStockTotal(@Param("tid")String tid, @Param("name")String name, @Param("code")String code,
			@Param("model")String model, @Param("brand")String brand);

}
