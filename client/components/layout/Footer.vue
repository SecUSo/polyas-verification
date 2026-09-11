    <template>
        <ul>
            <li><a accesskey="8" href="https://www.kit.edu/impressum.php" target="_blank">Impressum</a></li>

            <li><a href="https://www.kit.edu/datenschutz.php" target="_blank">Datenschutz</a></li>

            <li><a href="https://github.com/SecUSo/polyas-verification" target="_blank">Source Code</a>
            </li>

        </ul>
    </template>
<style scoped>
ul {
    list-style: none;
    padding: 0;
    margin: 0;
    display: flex;
    gap: 5px;
    font-weight: 300;
}

ul a {
    color: white;
    text-decoration: none;
    font-size: 0.8em;
}

li::after {
    content: "|";
    margin-left: 5px;
    color: white;
}

li:last-child::after {
    content: "";
    margin: 0;
}
</style>