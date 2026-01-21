## Tests
Tests can be either a tests.py in an app folder like app/tests.py or delete that file and create a folder app/tests that will contain a __init__.py and tests starting with test_nameofthetest.py

tests/
├── test_urls.py
├── test_views.py
├── test_serializers.py
└── test_models.py


Django Test Structure
```

from django.test import \
SimpleTestCase # Used for Tests that does not require database, good for utils testing. \
TestCase # Used for Tests that does require database, every test will be made inside a transaction and at the end the transaction will be rolled back \
TransactionTestCase # Database integration with actual commits, does not rollback, intead it deletes rows (truncation), use to test actual transactions or multiple databases \
LiveServerTestCase # Launches django server in the bg, used for integration tests with external tools, can make actual http requests, database integration included


class MyTestCase(TestCase):

    # Optional: Runs ONCE before all tests in this class
    @classmethod
    def setUpTestData(cls):
        # Create data that won't be modified
        cls.user = User.objects.create(username="testuser")

    # Optional: Runs BEFORE each test method
    def setUp(self):
        # Setup that runs before every test
        # Good for: authentication, creating fresh objects
        self.client.login(username="testuser", password="password")

    # Required: Test methods (must start with "test_")
    def test_something(self):
        # Your test code
        self.assertEqual(1 + 1, 2)

    def test_another_thing(self):
        # Another test
        self.assertTrue(True)

    # Optional: Runs AFTER each test method
    def tearDown(self):
        # Cleanup after each test (rarely needed with TestCase)
        pass
```
Assertions

## Django Test Assertions Reference

### Basic Equality & Comparison
```python
self.assertEqual(a, b)              #* Check if a == b - most used for basic comparisons
self.assertNotEqual(a, b)           # Check if a != b
self.assertGreater(a, b)            # Check if a > b
self.assertGreaterEqual(a, b)       # Check if a >= b
self.assertLess(a, b)               # Check if a < b
self.assertLessEqual(a, b)          # Check if a <= b
self.assertAlmostEqual(a, b)        # Check floats with tolerance (useful for decimals)
self.assertNotAlmostEqual(a, b)     # Check floats are NOT almost equal
```

### Boolean & Identity
```python
self.assertTrue(expr)               #* Check if expr is True - very common in validation tests
self.assertFalse(expr)              #* Check if expr is False - very common in validation tests
self.assertIs(a, b)                 # Check if a is b (same object)
self.assertIsNot(a, b)              # Check if a is not b
self.assertIsNone(value)            #* Check if value is None - common for optional fields
self.assertIsNotNone(value)         #* Check if value is not None - common for required fields
self.assertIsInstance(obj, cls)     # Check if obj is instance of cls
self.assertNotIsInstance(obj, cls)  # Check if obj is NOT instance of cls
self.assertIsSubclass(cls, parent)  # Check if cls inherits from parent
self.assertNotIsSubclass(cls, parent) # Check if cls doesn't inherit from parent
```

### Container & Membership
```python
self.assertIn(item, container)      #* Check if item in container - very common for lists/dicts
self.assertNotIn(item, container)   #* Check if item not in container - common for exclusion tests
self.assertListEqual([1,2], [1,2])  # Compare lists exactly
self.assertTupleEqual(t1, t2)       # Compare tuples exactly
self.assertSetEqual(s1, s2)         # Compare sets (order doesn't matter)
self.assertDictEqual(d1, d2)        # Compare dictionaries exactly
self.assertSequenceEqual(seq1, seq2) # Compare any sequence
self.assertCountEqual(lst1, lst2)   # Compare lists ignoring order
```

### String & Text
```python
self.assertStartsWith(text, prefix) # Check if text starts with prefix
self.assertNotStartsWith(text, prefix) # Check if text doesn't start with prefix
self.assertEndsWith(text, suffix)   # Check if text ends with suffix
self.assertNotEndsWith(text, suffix) # Check if text doesn't end with suffix
self.assertMultiLineEqual(str1, str2) # Compare multi-line strings with diff output
self.assertRegex(text, pattern)     # Check if pattern matches text
self.assertNotRegex(text, pattern)  # Check if pattern doesn't match text
```

### Django-Specific Assertions

#### HTML & Templates
```python
self.assertTemplateUsed(response, 'template.html')     #* Check template was used - essential for view tests
self.assertTemplateNotUsed(response, 'template.html')  # Check template wasn't used
self.assertHTMLEqual(html1, html2)          # Compare HTML ignoring whitespace/formatting
self.assertHTMLNotEqual(html1, html2)       # Check HTML content is different
self.assertInHTML(needle, haystack)         # Check HTML snippet exists in larger HTML
self.assertNotInHTML(needle, haystack)      # Check HTML snippet doesn't exist in HTML
```

#### HTTP Response Testing
```python
self.assertContains(response, text)         #* Check response contains text - most used for content validation
self.assertNotContains(response, text)      #* Check response doesn't contain text - common for security tests
self.assertContains(response, text, count=2) # Check text appears exactly N times
self.assertRedirects(response, url)         #* Check response redirects to url - essential for redirect tests
self.assertRedirects(response, '/login/', status_code=302, target_status_code=200) # Full redirect validation
self.assertURLEqual(url1, url2)            # Compare URLs handling query params and encoding
```

#### Database & Queries
```python
with self.assertNumQueries(expected_count): #* Check exact number of DB queries - critical for performance tests
    # Your code here that should generate specific number of queries
    pass

self.assertQuerySetEqual(qs1, qs2)         # Compare querysets (converts to lists)
```

#### Forms
```python
self.assertFormError(response, 'form', 'field', 'error message')     # Check specific form field error
self.assertFormSetError(response, 'formset', 0, 'field', 'error')    # Check formset field error
self.assertFieldOutput(field_class, valid_inputs, invalid_inputs)    # Test field validation with multiple inputs
```

### Data Format Testing
```python
self.assertJSONEqual(json1, json2)         #* Compare JSON strings - very common for API tests
self.assertJSONNotEqual(json1, json2)      # Check JSON strings differ
self.assertXMLEqual(xml1, xml2)            # Compare XML ignoring whitespace
self.assertXMLNotEqual(xml1, xml2)         # Check XML content differs
```

### Exception & Error Testing
```python
with self.assertRaises(ValueError):        #* Check specific exception is raised - essential for error handling tests
    # Code that should raise ValueError
    pass

with self.assertRaisesMessage(ValueError, 'specific error message'): # Check exception with exact message
    # Code that should raise ValueError with specific message
    pass

with self.assertRaisesRegex(ValueError, r'error.*pattern'): # Check exception message matches regex pattern
    # Code that should raise ValueError with message matching pattern
    pass
```

### Logging & Warnings
```python
with self.assertLogs('myapp.views', level='INFO') as logs: # Capture and test log messages
    # Code that should generate logs
    pass
    # Check logs.output, logs.records

with self.assertNoLogs('myapp.views', level='ERROR'): # Ensure no error logs generated
    # Code that should NOT generate error logs
    pass

with self.assertWarns(DeprecationWarning): # Check warning is issued
    # Code that should issue warning
    pass

with self.assertWarnsMessage(UserWarning, 'specific warning text'): # Check warning with specific message
    # Code that should warn with specific text
    pass

with self.assertWarnsRegex(UserWarning, r'warning.*pattern'): # Check warning message matches pattern
    # Code that should warn with pattern
    pass
```

### Attribute Testing
```python
self.assertHasAttr(obj, 'attribute_name')   # Check object has specific attribute
self.assertNotHasAttr(obj, 'attribute_name') # Check object doesn't have specific attribute
```

## Common Usage Patterns

### Model Testing
```python
def test_recipe_creation(self):
    recipe = Recipe.objects.create(title='Test Recipe', time_minutes=30)
    self.assertEqual(recipe.title, 'Test Recipe')    #* Basic field validation
    self.assertIsInstance(recipe, Recipe)            # Type checking
    self.assertIsNotNone(recipe.id)                  #* Ensure object was saved
    self.assertTrue(recipe.time_minutes > 0)         #* Business rule validation
```

### API Testing
```python
def test_api_list_recipes(self):
    response = self.client.get('/api/recipes/')
    self.assertEqual(response.status_code, 200)      #* Status code validation - most common
    self.assertContains(response, 'recipes')         #* Content validation - very common
    self.assertIn('application/json', response['Content-Type']) #* Header validation

    data = response.json()
    self.assertIsInstance(data, list)                #* Response structure validation
    self.assertGreater(len(data), 0)                 # Data presence validation
```

### Authentication Testing
```python
def test_login_required(self):
    response = self.client.get('/protected-view/')
    self.assertRedirects(response, '/login/')        #* Redirect validation - very common for auth

def test_user_can_access_own_data(self):
    self.client.force_authenticate(user=self.user)
    response = self.client.get('/api/my-recipes/')
    self.assertEqual(response.status_code, 200)      #* Status validation
    self.assertTrue(all(r['user'] == self.user.id for r in response.data)) #* Data filtering validation
```

### Performance Testing
```python
def test_prefetch_related_optimization(self):
    with self.assertNumQueries(2):                   #* Query count validation - critical for N+1 prevention
        recipes = Recipe.objects.prefetch_related('ingredients')
        for recipe in recipes:
            list(recipe.ingredients.all())  # Force evaluation
```

### Validation Testing
```python
def test_form_validation_errors(self):
    form_data = {'title': '', 'time_minutes': -5}   # Invalid data
    form = RecipeForm(data=form_data)
    self.assertFalse(form.is_valid())                #* Form validity check
    self.assertIn('title', form.errors)              #* Field error presence check
    self.assertIn('time_minutes', form.errors)       #* Multiple field validation
```
