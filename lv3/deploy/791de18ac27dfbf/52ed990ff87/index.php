<?php $mongo = new \MongoDB\Driver\Manager("mongodb://127.0.0.1:27017"); ?><!--debug: 与MongoDB建立连接ok-->
<?php
$loggedIn = false;
$loginFailed = false;
$isAdmin = false;
if(isset($_POST['username']) && isset($_POST['password'])){
	$rows = $mongo->executeQuery('shenmi.user', new \MongoDB\Driver\Query([
		'username' => $_POST['username'],
		'password' => $_POST['password']
	], []));
	$users = $rows->toArray();
	if(count($users)!==1){
		$loginFailed = true;
		echo "<!--debug: 应该只有一个用户被查出来的-->";
	} else {
		$loggedIn = true;
		$isAdmin = $users[0]->admin;
	}
}
?><!--debug: 判断登录信息ok-->
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width,initial-scale=1.0">
		<title>请先登录</title>
	</head>
	<body>
		<h1>欢迎来到申必系统！</h1>
<?php if(!$loggedIn){ ?><!--debug: 没有登录，给登录页面-->
		<h3><?php echo $loginFailed ? '登录失败！！！' : '请先登录！'; ?></h3>
		<p><i>为表彰发现这个系统的同志，特送出红包口令一个：<code>55286728</code></i>，和用户名密码一枚：<code>guest</code>/<code>guest</code>。</p>
		<form method="POST">
			用户名：<input type="text" name="username" />
			<br />
			密码：<input type="password" name="password" />
			<br />
			<input type="submit" value="登录" />
		</form>
<?php } else { ?><!--debug: 判断是不是管理员 ok-->
		<h2>记事板</h2>
		<textarea rows="10" cols="60"><?php echo $isAdmin ? "最后一关: 2020wow2020.hb.lohu.info" : "你又不是 admin，你看你🐎呢？"; ?></textarea>
<?php } ?>
	</body>
</html>
<!--debug: 记录访问数据-->
<!--debug:销毁连接-->