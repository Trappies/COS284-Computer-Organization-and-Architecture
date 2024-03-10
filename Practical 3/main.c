#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>
#define EPSILON 0.0001

struct Book
{
    char isbn[13];
    char title[50];
    float price;
    int quantity;
};

struct Library
{
    struct Book books[5];
    int count;
};

struct Library *initialiseLibrary(void);
int addBook(struct Library *lib, struct Book *book);
struct Book *searchBookByISBN(struct Library *lib, char *isbn);
extern struct Book *allocateBook(char *isbn, char *title, float price, int quantity);

void printBookDetails(struct Book book)
{
    printf("ISBN: %s\n", book.isbn);
    printf("Title: %s\n", book.title);
    printf("Price: %.2f\n", book.price);
    printf("Quantity: %d\n", book.quantity);
}

int main()
{
    /*
        As always, this will only partially test your code. Please write more rigorous tests
        to verify that everything is as expected. That means testing negative flows as well as edge cases.
    */
    // Initialising library and asserting it's not NULL
    struct Library *lib = initialiseLibrary();
    assert(lib != NULL);

    // Testing addition of books to the library
    struct Book *book1 = allocateBook("978316148\0", "The C Programming Language\0", 9.99, 10);
    printBookDetails(*book1);
    assert(addBook(lib, book1) == 1);
    assert(lib->count == 1);                                                  // Testing if the library count is correct
    assert(lib->books[0].quantity == 10);                                     // Testing if the quantity is correct
    assert(fabs(lib->books[0].price - 9.99) < EPSILON);                       // Testing if the price is correct
    assert(strcmp(lib->books[0].isbn, "978316148\0") == 0);                   // Testing if the ISBN is correct
    assert(strcmp(lib->books[0].title, "The C Programming Language\0") == 0); // Testing if the title is correct

    struct Book *book2 = allocateBook("978012345\0", "Another Book Title\0", 15.49, 5);
    assert(addBook(lib, book2) == 1);
    assert(lib->count == 2); // Testing if the library count is correct
    // Testing if the first book is still there
    assert(lib->books[0].quantity == 10);                                     // Testing if the quantity is correct
    assert(fabs(lib->books[0].price - 9.99) < EPSILON);                       // Testing if the price is correct
    assert(strcmp(lib->books[0].isbn, "978316148\0") == 0);                   // Testing if the ISBN is correct
    assert(strcmp(lib->books[0].title, "The C Programming Language\0") == 0); // Testing if the title is correct
    // Testing if the second book is added correctly
    assert(lib->books[1].quantity == 5);                              // Testing if the quantity is correct
    assert(fabs(lib->books[1].price - 15.49) < EPSILON);              // Testing if the price is correct
    assert(strcmp(lib->books[1].isbn, "978012345\0") == 0);           // Testing if the ISBN is correct
    assert(strcmp(lib->books[1].title, "Another Book Title\0") == 0); // Testing if the title is correct

    // Testing duplicate ISBN (should update quantity)
    struct Book *book3 = allocateBook("978316148\0", "The C Programming Language\0", 9.99, 5);
    assert(addBook(lib, book3) == 1);
    struct Book *searchResult = searchBookByISBN(lib, "978316148\0");
    assert(searchResult != NULL);
    assert(searchResult->quantity == 15);

    // Testing the library limit
    assert(addBook(lib, allocateBook("978098765\0", "Yet Another Book\0", 20.89, 7)) == 1);
    assert(addBook(lib, allocateBook("978111111\0", "Some Book\0", 10.0, 2)) == 1);
    assert(addBook(lib, allocateBook("978222222\0", "Some Other Book\0", 5.0, 3)) == 1);
    // This next book should fail
    assert(addBook(lib, allocateBook("978333333\0", "How to live with yourself\0", 5.0, 3)) == 0);

    // Testing book search by ISBN
    searchResult = searchBookByISBN(lib, "978316148\0");
    assert(searchResult != NULL);
    assert(strcmp(searchResult->isbn, "978316148\0") == 0);

    // Testing for non-existing ISBN
    searchResult = searchBookByISBN(lib, "978000000\0");
    assert(searchResult == NULL);

    // Testing if the library count is correct
    assert(lib->count == 5);

    // Cleanup
    free(lib);

    printf("All tests passed successfully.\n");

    return 0;
}
