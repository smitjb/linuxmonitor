select free_space, avg_free_size, used_space, avg_used_size, request_failures, last_failure_size
from v$shared_pool_reserved;
