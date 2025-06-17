<?php
if (isset($argv[1]) === false) {
//    die("pass path to composer.json as argument");
    $path = getcwd() . '/composer.json';
} elseif (str_starts_with($argv[1], '/')) {
    $path = $argv;
} else {
    $path = getcwd() . '/' . $argv[1];
}
$compose = json_decode(file_get_contents($path), true)['require'];
$matches = [];
foreach ($compose as $extension => $version) {
    if (str_starts_with($extension, 'ext-') || $extension === 'php') {
        continue;
    }
//    echo $extension . ' => ' . $version . PHP_EOL;
    if (preg_match('/\d+/', $version, $matches)) {
        $currentMajorVersion = (int) $matches[0];

        $output = shell_exec("composer show -a $extension 2>./tmp.txt | grep versions");
        if (file_exists('tmp.txt')) {
            $error = file_get_contents('tmp.txt');
            if (strlen($error)) {
                echo 'An error has occurred while checking '
                    . $extension
                    . ': '
                    . file_get_contents('tmp.txt');
            }
            unlink('tmp.txt');
        }

        $allVersions = array_map('trim', explode(',', substr($output, strpos($output, ':') + 1)));
        foreach ($allVersions as $remoteVersion) {
            if (preg_match('/(dev|rc|beta|alpha)/i', $remoteVersion)) {
                continue;
            }
            $newestVersion = $remoteVersion;
            break;
        }
        if (isset($newestVersion) === false) {
            echo "No applicable version for $extension!" . PHP_EOL;
            continue;
        }
        preg_match('/\d+/', $newestVersion, $matches);
        $newestMajorVersion = (int) $matches[0];
        if ($currentMajorVersion < $newestMajorVersion) {
            echo $extension . ' has a newer major version: ' . $newestMajorVersion . ' (current = ' . $currentMajorVersion . ')' . PHP_EOL;
        }
    }
}
