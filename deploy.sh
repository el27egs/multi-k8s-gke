docker build -t emmanuelgarciads/multi-client:latest -t emmanuelgarciads/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t emmanuelgarciads/multi-server:latest -t emmanuelgarciads/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t emmanuelgarciads/multi-worker:latest -t emmanuelgarciads/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push emmanuelgarciads/multi-client:latest
docker push emmanuelgarciads/multi-server:latest
docker push emmanuelgarciads/multi-worker:latest

docker push emmanuelgarciads/multi-client:$SHA
docker push emmanuelgarciads/multi-server:$SHA
docker push emmanuelgarciads/multi-worker:$SHA

kubectl apply -f postgres-deployment.yaml
sleep 30

kubectl apply -f redis-deployment.yaml
sleep 30

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=emmanuelgarciads/multi-server:$SHA
kubectl set image deployments/client-deployment client=emmanuelgarciads/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=emmanuelgarciads/multi-worker:$SHA