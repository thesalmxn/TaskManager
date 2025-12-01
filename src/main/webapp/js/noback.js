// Prevent back button navigation after logout
history.pushState(null, null, location.href);
window.onpopstate = function () {
    history.go(1);
};

// Clear form cache
window.onpageshow = function(event) {
    if (event.persisted) {
        window.location.reload();
    }
};

// Prevent form resubmission on refresh
if (window.history.replaceState) {
    window.history.replaceState(null, null, window.location.href);
}