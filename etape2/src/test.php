<?php
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT); // utile en dev
$mysqli = new mysqli('data', 'monuser', 'password', 'mabase');
$mysqli->set_charset('utf8mb4');

// 1) Insert : pas de $result ici
$ok = $mysqli->query("INSERT INTO matable (compteur) SELECT COUNT(*)+1 FROM matable;");
if ($ok) {
    printf("Count updated<br />");
    printf("Affected rows : %d<br />", $mysqli->affected_rows);
}

// 2) Select : là on a un $result
$result = $mysqli->query("SELECT * FROM matable");
printf("Count : %d<br />", $result->num_rows);
$result->close();

$mysqli->close();
