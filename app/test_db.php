<?php
$link = mysqli_connect("db", "root", $_ENV['MARIADB_ROOT_PASSWORD'], null);

if (!$link) {
    echo "Error: Unable to connect to MariaDB." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    exit;
}

echo "Success: A proper connection to MariaDB was made! The docker database is great." . PHP_EOL;

mysqli_close($link);