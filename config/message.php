<?php

// +----------------------------------------------------------------------
// | 缓存设置
// +----------------------------------------------------------------------

return [
    // 系统消息模板
    'template'  => [
        1 => [
			'title'       => '{from_user}发了一个新『公告』，请及时查看',
            'content' => '您有一个新公告：{title}。',
            'link' => '<a class="link-a" data-href="/note/index/view/id/{action_id}">查看详情</a>',
        ],
        21 => [
			'title'       => '{from_user}提交了一个『{title}申请』，请及时审批',
            'content' => '您有一个新的『{title}审批』需要处理。',
			'link' => '<a class="link-a" data-href="/oa/approve/view/id/{action_id}">去审批</a>',
        ],
        22 => [
			'title'       => '您提交的『{title}申请』已被审批通过',
            'content' => '您在{create_time}提交的『{title}申请』已于{date}被审批通过。',
			'link' => '<a class="link-a" data-href="/oa/approve/view/id/{action_id}">查看详情</a>',
        ],
        23 => [
			'title'       => '您提交的『{title}申请』已被驳回拒绝',
            'content' => '您在{create_time}提交的『{title}申请』已于{date}被驳回拒绝。',
			'link' => '<a class="link-a" data-href="/oa/approve/view/id/{action_id}">查看详情</a>',
        ],
		31 => [
			'title'       => '{from_user}提交了一个『报销申请』，请及时审批',
            'content' => '您有一个新的『报销审批』需要处理。',
			'link' => '<a class="link-a" data-href="/finance/expense/view/id/{action_id}">去审批</a>',
        ],
        32 => [
			'title'       => '您提交的『报销申请』已被审批通过',
            'content' => '您在{create_time}提交的『报销申请』已于{date}被审批通过。',
			'link' => '<a class="link-a" data-href="/finance/expense/view/id/{action_id}">查看详情</a>',
        ],
        33 => [
			'title'       => '您提交的『报销申请』已被驳回拒绝',
            'content' => '您在{create_time}提交的『报销申请』已于{date}被驳回拒绝。',
			'link' => '<a class="link-a" data-href="/finance/expense/view/id/{action_id}">查看详情</a>',
        ],
        34 => [
			'title'       => '您提交的『报销申请』已发放',
            'content' => '您在{create_time}提交的『报销申请』已经发放，请查看是否到账。',
			'link' => '<a class="link-a" data-href="/finance/expense/view/id/{action_id}">查看详情</a>',
        ],
        41 => [
			'title'       => '{from_user}提交了一个『发票申请』，请及时审批',
            'content' => '您有一个新的『发票申请』需要处理。',
			'link' => '<a class="link-a" data-href="/oa/approve/view/id/{action_id}">去审批</a>',
        ],
        42 => [
			'title'       => '您提交的『发票申请』已被审批通过',
            'content' => '您在{create_time}提交的『发票申请』已于{date}被审批通过。',
			'link' => '<a class="link-a" data-href="/oa/approve/view/id/{action_id}">查看详情</a>',
        ],
        43 => [
			'title'       => '您提交的『发票申请』已被驳回拒绝',
            'content' => '您在{create_time}提交的『发票申请』已于{date}被驳回拒绝。',
			'link' => '<a class="link-a" data-href="/oa/approve/view/id/{action_id}">查看详情</a>',
        ],
	]
];
