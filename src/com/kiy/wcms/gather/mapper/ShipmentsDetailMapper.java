package com.kiy.wcms.gather.mapper;

import java.util.List;

import com.kiy.wcms.gather.entity.ShipmentsDetail;

public interface ShipmentsDetailMapper {
	/**
	 * 保存
	 * @param detail
	 */
	public void save(ShipmentsDetail detail);
	
	/**
	 * 获取发货申请单明细
	 * @param shipmentsId
	 * @return
	 */
	public List<ShipmentsDetail> getShipmentsDetails(String shipmentsId);
	
	/**
	 * 删除发货申请单明细
	 * @param id
	 */
	public void deleteShipmentsDetail(String id);
	
	/**
	 * 根据发货申请单ID删除明细
	 * @param id
	 */
	public void deleteByShipId(String id);

}
