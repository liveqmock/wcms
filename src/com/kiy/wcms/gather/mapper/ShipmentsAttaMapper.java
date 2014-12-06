package com.kiy.wcms.gather.mapper;

import java.util.List;

import com.kiy.wcms.gather.entity.ShipmentsAtta;

public interface ShipmentsAttaMapper {
	/**
	 * 保存发货申请单附件
	 * @param ship
	 */
	public void save(ShipmentsAtta ship);
	
	/**
	 * 获取附件列表
	 * @param id
	 * @return
	 */
	public List<ShipmentsAtta> getList(String id);
	
	/**
	 * 获取附件路径
	 * @param id
	 * @return
	 */
	public String getPath(String id);
	
	/**
	 * 删除附件信息
	 * @param id
	 */
	public void delete(String id);
	
	/**
	 * 根据发货申请单ID删除附件
	 * @param id
	 */
	public void deleteByShipId(String id);

}
