var app = angular.module('app', [])
    .controller('appController', function ($scope, $http, $window) {
        var urlQuestion = "http://localhost:8080/ws/question/all";
        var urlAnswer = "http://localhost:8080/ws/answer";
        var count = 0;
        var questions = [];
        var responses = {};
        $scope.showQuestion = true;

        $http.get(urlQuestion).success(
            function (data) {
                questions = data;
                $scope.question = data[count];
            }
        );

        $scope.answer = function (answer) {
            responses[questions[count].value] = answer;

            if (count < questions.length - 1)
                $scope.question = questions[++count];
            else
                sendResponse(responses);

        };

        $scope.reconsult = function () {
            $window.location.reload();
        };

        function sendResponse(responses) {
            $scope.showQuestion = false;

            $http.post(urlAnswer, responses).success(
                function (data) {
                    $scope.answers = data;
                }
            );
        };
    });