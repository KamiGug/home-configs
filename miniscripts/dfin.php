ob_start();
var_dump();
file_put_contents('/tmp/df.log', ob_get_clean() . PHP_EOL, FILE_APPEND);
