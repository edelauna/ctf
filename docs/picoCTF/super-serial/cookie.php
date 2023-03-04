<?php
session_start();

class permissions
{
  public $username;
  public $password;

  function __construct($u, $p)
  {
    $this->username = $u;
    $this->password = $p;
  }

  function __toString()
  {
    return $this->username . $this->password;
  }

  function is_guest()
  {
    return false;
  }

  function is_admin()
  {
    return true;
  }
}

if (isset($_COOKIE["login"])) {
  try {
    $perm = unserialize(base64_decode(urldecode($_COOKIE["login"])));
    $g = $perm->is_guest();
    $a = $perm->is_admin();
  } catch (Error $e) {
    die("Deserialization error. " . $perm);
  }
}
?>