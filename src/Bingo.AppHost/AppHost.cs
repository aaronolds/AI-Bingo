var builder = DistributedApplication.CreateBuilder(args);

var postgres = builder.AddPostgres("postgres").AddDatabase("bingo");
var redis = builder.AddRedis("redis");

builder.AddProject("bingo-api", "../Bingo.Api/Bingo.Api.csproj")
	.WithReference(postgres)
	.WithReference(redis);

builder.Build().Run();
