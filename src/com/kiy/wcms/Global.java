package com.kiy.wcms;

public class Global {
	public static final String LOGIN_USER = "login_user";
	
	/**
	 * 审批记录类型  - 订单
	 */
	public static final int AUDIT_TYPE_ORDER = 1;
	/**
	 * 审批记录类型 - 生产计划
	 */
	public static final int AUDIT_TYPE_PRODUCTPLAN = 2;
	/**
	 * 审批记录类型 - 设计方案
	 */
	public static final int AUDIT_TYPE_DESIGN = 3;
	/**
	 * 审批记录类型 - 收款单
	 */
	public static final int AUDIT_TYPE_GATHER = 4;
	/**
	 * 审批记录类型 - 发货申请单
	 */
	public static final int AUDIT_TYPE_SHIPMENTS = 5;
	/**
	 * 审批记录类型 - 采购计划
	 */
	public static final int AUDIT_TYPE_PROCUREMENTPLAN = 6;
	/**
	 * 审批记录类型 - 采购订单
	 */
	public static final int AUDIT_TYPE_PROCUREMENTCONTRACT = 7;
	/**
	 * 审批记录类型 - 付款申请单
	 */
	public static final int AUDIT_TYPE_PAYMENT = 8;
}
