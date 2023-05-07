<html>
<head>
   <title>Sentence of the Day</title>
</head>
<body>
   <h1>Sentence of the Day</h1>

<?php
   $database = "sentences";
   $user = "root";
   $password  = "12345";
   $host = "db";

   try {
      $connection = new PDO("mysql:host={$host};dbname={$database};charset=utf8", $user, $password);
      $query = $connection->query("SELECT * FROM sentences ORDER BY RAND() LIMIT 1");
      $commands = $query->fetchAll();

      if (empty($commands)) {
         echo "<h3>There is no information in the database</h3>\n";
      } else {
         echo "<h3>".$commands[0]['s_text']."</h3>\n";
      }
   }
   catch (PDOException $e) {
      print "<h3>There is no database available. Try again later.</h3>\n";
   }
?>
</body>
</html>
