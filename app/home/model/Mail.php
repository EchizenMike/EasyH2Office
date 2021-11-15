<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

namespace app\home\model;

use think\Model;

class Mail extends Model
{
    // 垃圾消息来源[delete_source]
    const SOURCE_ZERO = 0;
    const SOURCE_ONE = 1;
    const SOURCE_TWO = 2;
    const SOURCE_THREE = 3;

    // 阅览人类型[type]
    const TYPE_ZERO = 0;
    const TYPE_ONE = 1;
    const TYPE_TWO = 2;
    const TYPE_THREE = 3;

    // 是否已读[is_read]
    const READ_ONE = 1;
    const READ_TWO = 2;

    // 消息来源[mail_type]
    const MAILTYPE_ZERO = 0;
    const MAILTYPE_ONE = 1;
    const MAILTYPE_TWO = 2;
    const MAILTYPE_THREE = 3;

    public static $Source = [
        self::SOURCE_ZERO => '无',
        self::SOURCE_ONE => '已发消息',
        self::SOURCE_TWO => '草稿消息',
        self::SOURCE_THREE => '已收消息',
    ];

    public static $Type = [
        self::TYPE_ZERO => '同事',
        self::TYPE_ONE => '部门',
        self::TYPE_TWO => '岗位',
        self::TYPE_THREE => '全部',
    ];

    public static $MailType = [
        self::MAILTYPE_ONE => '系统消息',
        self::SOURCE_TWO => '同事消息',
    ];

    public static $Read = [
        self::READ_ONE => '未读',
        self::READ_TWO => '已读',
    ];

}
