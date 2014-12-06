package com.kiy.wcms.gather.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.gather.entity.Gather;
import com.kiy.wcms.gather.entity.GatherOrder;
import com.kiy.wcms.gather.entity.GatherParam;

public interface GatherMapper {
	/**
	 * 展示订单
	 * @param param
	 * @return
	 */
	public List<GatherOrder> showOrders(GatherParam param);
	/**
	 * 展示订单总数
	 * @param param
	 * @return
	 */
	public int showTotal(GatherParam param);
	/**
	 * 根据订单号获取收款单列表
	 * @param orderId
	 * @param begin
	 * @param rows
	 * @return
	 */
	public List<Gather> getGatherList(@Param("orderId")String orderId, @Param("begin")int begin, 
			@Param("rows")Integer rows);
	/**
	 * 收款单总数
	 * @param orderId
	 * @return
	 */
	public int getGatherTotal(String orderId);
	
	/**
	 * 获取下一个收款单号
	 * @return
	 */
	public Integer getNextNo();
	
	/**
	 * 保存收款单
	 * @param gather
	 */
	public void saveGather(Gather gather);
	
	/**
	 * 更新收款单
	 * @param gather
	 */
	public void updateGather(Gather gather);
	
	/**
	 * 删除请款单
	 * @param id
	 */
	public void deleteGather(int id);
	
	/**
	 * 提交请款单
	 * @param id
	 */
	public void submitGather(int id);
	
	/**
	 * 获取审批列表
	 * @param param
	 * @return
	 */
	public List<Gather> getAuditGatherList(GatherParam param);
	
	/**
	 * 获取总数
	 * @param param
	 * @return
	 */
	public int getTotal(GatherParam param);
	
	/**
	 * 收款单列表
	 * @param id
	 * @return
	 */
	public List<Gather> getHisGatherList(String id);
	
	/**
	 * 提交审批
	 * @param id
	 * @param status
	 */
	public void submitAudit(@Param("id")String id, @Param("status")int status);
	
	/**
	 * 获取订单详情及收款情况
	 * @param orderId
	 * @return
	 */
	public GatherOrder getGatherOrderById(String orderId);
	
	/**
	 * 获取订单待收款总数
	 * @return
	 */
	public int getUnGatherTotal();
	
	/**
	 * 获取被退回收款单总数
	 * @return
	 */
	public int getBackGatherTotal();
	
	/**
	 * 获取待审批收款单总数
	 * @param seeStatus
	 * @return
	 */
	public int getUnAuditGatherTotal(String seeStatus);
	
	/**
	 * 获取收款单列表
	 * @param orderId
	 * @return
	 */
	public List<Gather> getGathersByOrder(String orderId);

}
