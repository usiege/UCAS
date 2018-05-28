from sklearn.datasets import load_iris
from sklearn.cluster import KMeans
from sklearn.cross_validation import train_test_split
from sklearn import metrics
from sklearn.neighbors import KNeighborsClassifier
from sklearn import svm
from sklearn.linear_model import LogisticRegression

def  kmeans(x_train,x_test,y_test):
    clf = KMeans(n_clusters=3)
    model = clf.fit(x_train)
    y_predicted = model.predict(x_test)
    acc=metrics.adjusted_rand_score(y_test,y_predicted)
    print(acc)

def  KNN(x_train, y_train,x_test,y_test):
    knn = KNeighborsClassifier(3).fit(x_train, y_train)
    print(knn.score(x_test, y_test))

def SVM_classification(x_train, y_train,x_test,y_test):
    model = svm.SVC().fit(x_train, y_train)
    print(model.score(x_test, y_test))
def Logistic_classification(x_train, y_train,x_test,y_test):
    model = LogisticRegression().fit(x_train, y_train)
    print(model.score(x_test, y_test))


if __name__ == '__main__':
    iris = load_iris()
    x = iris.data
    y = iris.target
    x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=0)
    #kmeans(x_train,x_test,y_test)
    #KNN(x_train, y_train,x_test,y_test)
    #SVM_classification(x_train, y_train,x_test,y_test)
    Logistic_classification(x_train, y_train,x_test,y_test)
