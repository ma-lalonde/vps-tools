#!/bin/bash
# ERPNext may not start properly on boot, whch may be fixed by restarting the project.
# Add this to crontab:
#
# crontab -e
# @reboot sleep 30 && /path/to/restart_erpnext.sh
docker restart erpnext_frappe-socketio_1 &
docker restart erpnext_site-creator_1 &
docker restart erpnext_erpnext-worker-short_1 &
docker restart erpnext_erpnext-worker-default_1 &
docker restart erpnext_erpnext-worker-long_1 &
docker restart erpnext_erpnext-schedule_1 &
docker restart erpnext_erpnext-nginx_1 &
docker restart erpnext_erpnext-python_1 &
docker restart erpnext_redis-queue_1 &
docker restart erpnext_redis-socketio_1 &
docker restart erpnext_redis-cache_1 &
docker restart erpnext_mariadb_1 &