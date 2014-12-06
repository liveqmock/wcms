package com.kiy.wcms.entrepot.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.entrepot.entity.Warning;
import com.kiy.wcms.entrepot.entity.WarningSetting;

//库存预警
public interface WarningMapper {
	/**
	 * 保存库存预警设置
	 * @param setting
	 */
	public void save(WarningSetting setting);
	/**
	 * 获取预警设置列表
	 * @param begin
	 * @param rows
	 * @param goodsName
	 * @param goodsModel
	 * @param goodsBrand
	 * @return
	 */
	public List<WarningSetting> getWarningSettingList(@Param("begin")int begin, @Param("rows")Integer rows,
			@Param("goodsName")String goodsName, @Param("goodsModel")String goodsModel, 
			@Param("goodsBrand")String goodsBrand);
	/**
	 * 获取预警设置列表总数
	 * @param goodsName
	 * @param goodsModel
	 * @param goodsBrand
	 * @return
	 */
	public int getWarningSettingTotal(@Param("goodsName")String goodsName, @Param("goodsModel")String goodsModel,
			@Param("goodsBrand")String goodsBrand);
	
	/**
	 * 获取预警列表
	 * @param begin
	 * @param rows
	 * @param goodsName
	 * @param goodsModel
	 * @param goodsBrand
	 * @return
	 */
	public List<Warning> getWarningList(@Param("begin")int begin, @Param("rows")Integer rows,
			@Param("goodsName")String goodsName, @Param("goodsModel")String goodsModel, @Param("goodsBrand")String goodsBrand);
	
	/**
	 * 获取预警总数
	 * @param goodsName
	 * @param goodsModel
	 * @param goodsBrand
	 * @return
	 */
	public int getWarningTotal(@Param("goodsName")String goodsName, @Param("goodsModel")String goodsModel,
			@Param("goodsBrand")String goodsBrand);
	
	/**
	 * 删除预警设置信息
	 * @param id
	 */
	public void delete(String id);

}
