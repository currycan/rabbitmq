resource rabbitmq {
    protocol C; #使用协议
    meta-disk internal;
    device /dev/drbd0;
    meta-disk internal;
    on ha_node1 {
        address 192.168.39.101:7789;
        disk /dev/sdb; # 使用磁盘/dev/sdb创建新设备的/dev/drbd0
    }
    on ha_node2 {
        address 192.168.39.109:7789;
        disk /dev/sdb;
    }
    syncer {
        rate 40M;
    }
#    syncer {
#        verify-alg sha1;# 加密算法
#    }
    net {
        after-sb-0pri discard-zero-changes;
        after-sb-1pri discard-secondary;
    }
}
