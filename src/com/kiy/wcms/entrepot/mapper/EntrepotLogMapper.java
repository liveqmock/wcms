package com.kiy.wcms.entrepot.mapper;

import java.util.List;

import com.kiy.wcms.entrepot.entity.EntrepotLog;
import com.kiy.wcms.entrepot.entity.EntrepotParam;

public interface EntrepotLogMapper {
	/**
	 * 获取下一个入库单号
	 * @return
	 */
	public Integer getNextInEntrepotCode();
	
	/**
	 * 入库
	 * @param log
	 */
	public void inEntrepot(EntrepotLog log);
	
	/**
	 * 获取入库记录列表
	 * @param param
	 * @return
	 */
	public List<EntrepotLog> getInEntrepotList(EntrepotParam param);
	
	/**
	 * 获取入库记录总数
	 * @param param
	 * @return
	 */
	public int getInEntrepotTotal(EntrepotParam param);
	
	/**
	 * 出库
	 * @param log
	 */
	public void outEntrepot(EntrepotLog log);
	
	/**
	 * 获取下一个出库单编号
	 * @return
	 */
	public Integer getNextOutEntrepotCode();
	
	/**
	 * 获取出库记录列表
	 * @param param
	 * @return
	 */
	public List<EntrepotLog> getOutEntrepotList(EntrepotParam param);
	
	/**
	 * 获取出库记录总数
	 * @param param
	 * @return
	 */
	public int getOutEntrepotTotal(EntrepotParam param);

	
	
}
