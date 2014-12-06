package com.kiy.wcms.gather.mapper;

import java.util.List;

import com.kiy.wcms.gather.entity.Delivery;
import com.kiy.wcms.gather.entity.GatherParam;
import com.kiy.wcms.gather.entity.ShipmentsDetail;

public interface DeliveryMapper {
	/**
	 * 获取下一个送货单编号
	 * @return
	 */
	public Integer getNextNo();
	
	/**
	 * 保存送货单
	 * @param delivery
	 */
	public void save(Delivery delivery);
	
	/**
	 * 获取送货单列表
	 * @param param
	 * @return
	 */
	public List<Delivery> getList(GatherParam param);

	/**
	 * 获取送货单总数
	 * @param param
	 * @return
	 */
	public int getTotal(GatherParam param);
	
	/**
	 * 更新送货单
	 * @param delivery
	 */
	public void update(Delivery delivery);
	
	/**
	 * 生效送货单
	 * @param id
	 */
	public void effectDelivery(String id);
	
	/**
	 * 获取待提交总数
	 * @return
	 */
	public int getUnPayTotal();
	
	/**
	 * 根据ID获取送货单基础数据
	 * @param id
	 * @return
	 */
	public Delivery getDeliveryById(String id);
	
	/**
	 * 根据送货单ID获取送货清单
	 * @param id
	 * @return
	 */
	public List<ShipmentsDetail> getShipDetailsByDeliId(String id);

}
