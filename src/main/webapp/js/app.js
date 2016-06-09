var app = angular.module('app',[]);

app.controller('appController',function ($scope) {
    $scope.first = 0;
    $scope.second = 0;

    $scope.calculate = function () {
        $scope.result = $scope.first + $scope.second;
    };

    $scope.getQuestion = function () {
        return 'view/question.html';
    };
});