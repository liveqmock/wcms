package com.kiy.wcms.producplan.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.order.entity.Order;
import com.kiy.wcms.order.entity.OrderDetail;
import com.kiy.wcms.producplan.entity.ProducPlan;
import com.kiy.wcms.producplan.entity.ProducPlanParam;

public interface ProducPlanMapper {
	/**
	 * 生成生成计划
	 * @param id   订单ID
	 */
	public void save(String id);
	
	/**
	 * 获取生成计划列表
	 * @param producPlanParam
	 * @return
	 */
	public List<ProducPlan> getProducPlanList(ProducPlanParam producPlanParam);
	
	/**
	 * 获取生成计划总数
	 * @param producPlanParam
	 * @return
	 */
	public int getTotal(ProducPlanParam producPlanParam);
	
	/**
	 * 保存技术参数
	 * @param orderDetail
	 */
	public void saveTechParam(OrderDetail orderDetail);
	
	/**
	 * 提交生成计划
	 * @param id
	 */
	public void submitProducPlan(String id);

	/**
	 * 获取审批列表
	 * @param param
	 * @return
	 */
	public List<ProducPlan> getAuditList(ProducPlanParam param);

	/**
	 * 获取审批列表总数
	 * @param param
	 * @return
	 */
	public int getAuditTotal(ProducPlanParam param);
	
	/**
	 * 提交审批
	 * @param id
	 * @param status
	 */
	public void submitAudit(@Param("id")String id, @Param("status")int status);
	
	/**
	 * 获取订单明细ID
	 * @param id
	 * @return
	 */
	public List<Integer> getDetailIdList(String id);
	
	/**
	 * 获取被退回总数
	 * @return
	 */
	public int getBackTotal();
	
	/**
	 * 获取未提交总数
	 * @return
	 */
	public int getUnPayTotal();
	
	/**
	 * 根据项目计划单ID获取订单内容
	 * @param id
	 * @return
	 */
	public Order getOrderByProId(String id);
	
	/**
	 * 获取订单产品明细
	 * @param id
	 * @return
	 */
	public List<OrderDetail> getOrderDetailListByProId(String id);

}
